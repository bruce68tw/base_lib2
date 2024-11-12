//import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../enums/all.dart';
import '../models/all.dart';
import 'all.dart';

//pager service
class CrudRead {

  //constant
  static const _errorCode = '-1';

  //only input value, no fid in it
  final List<dynamic> _sqlArgs = [];

  ///rows count per page
  //late int _pageRows;


  ///constructor
  //CrudRead() {
  //}
  
  Future<Map<String, dynamic>?> getPageBySqlA(String sql, DtDto dtDto) async {
    var readDto = ReadDto(readSql: sql);
    return await getPageA(readDto, dtDto);
  }

  Future<Map<String, dynamic>?> getPageA(ReadDto readDto, DtDto dtDto) async {
      //#region 1.check input
      dtDto.length = PageUt.getPageRows(dtDto.length);
      //#endregion

      //#region 2.get sql
      var sqlDto = SqlUt.sqlToDto(readDto.readSql, readDto.useSquare);
      if (sqlDto == null) return null;

      //prepare sql where & set sql args by user input condition
      //var search = (dtDto.search == null) ? "" : dtDto.search.value;
      var where = await getWhereA(readDto, StrUt.toJson(dtDto.findJson));
      if (where == _errorCode) return JsonUt.getError();
      //else if(where == "-2")
      //    return _Json.GetBrError(_Fun.TimeOutFid);

      if (where != ""){
          sqlDto.where = (sqlDto.where == "") 
              ? "Where " + where 
              : sqlDto.where + " And " + where;
      }
      //#endregion

      //#region 3.get rows count if need
      //List<Map<String, dynamic>>? rows;
      //var db = GetDb();
      var rowCount = dtDto.recordsFiltered;
      var group = (sqlDto.group == "") ? "" : " " + sqlDto.group; //remove last space
      String sql;
      if (rowCount < 0)
      {
          sql = "Select Count(*) as _count " +
              sqlDto.from + " " +
              sqlDto.where +
              group;
          var row = await DbUt.getJsonA(sql, _sqlArgs); //for log carrier
          if (row == null) {
            return {
              //'draw': dtDto.draw,
              'data': null,
              'recordsFiltered': 0,
            };
          }

          //case of ok
          rowCount = row["_count"];
      }
      //#endregion

      /*
      //#region 4.sql add sorting
      var orderColumn = (dtDto.order == null || dtDto.order.Count == 0) 
          ? -1 : dtDto.order[0].column;
      if (orderColumn >= 0)
          sqlDto.Order = "Order By " + 
              sqlDto.Columns[orderColumn].Trim() + 
              (dtDto.order[0].dir == OrderTypeEnum.Asc ? "" : " Desc");
      //#endregion
      */

      //#region 5.get page rows 
      sql = SqlUt.dtoToSql(sqlDto, dtDto.start, dtDto.length);
      var rows = await DbUt.getJsonsA(sql, _sqlArgs);
      //#endregion

  //lab_exit:
      //close db
      //await db.DisposeAsync();

      //return result
      return {
        //'draw': dtDto.draw,
        'data': rows,
        'recordsFiltered': rowCount,
      };
  }

  void _addArg(String fid, dynamic value) {
      _sqlArgs.add(fid);
      _sqlArgs.add(value);
  }

  Future<String> getWhereA(ReadDto readDto, Map<String, dynamic>? findJson) async {

      //#region set variables
      //var groupLen = 0; //(readDto.orGroups == null || readDto.OrGroups.Count == 0) ? 0 : readDto.OrGroups.Count;
      //var orWheres = new string[groupLen == 0 ? 1 : groupLen];
      List<String> okDates = [];     //date field be done(date always has start/end)
      var items = readDto.items;
      var itemWhere = "";
      //var error = "";
      //const errorCode = "-1";
      //#endregion

      //#region 1.where add condition
      var where = "";
      var and = "";
      if (items != null && items.isNotEmpty && findJson != null) {
          var table = StrUt.isEmpty(readDto.tableAs) ? "" : (readDto.tableAs + ".");
          //foreach 不能使用 continue !!
          for(var prop in findJson.entries) {
              //skip if empty
              var value = prop.value;
              if (ObjectUt.isEmpty(value)) continue;

              //#region if query field not existed(and field name is not underline), skip & log
              var item = items.firstWhereOrNull((a)=> a.fid == prop.key);
              if (item == null) {
                  //1.underline field(reserve field), 2.done date field
                  var key = prop.key;
                  var len = key.length;
                  //field name not underline
                  if (key.substring(0,1) == "_") continue;

                  //field name tail is 2, for date field
                  if (key.substring(len - 1) == "2") {
                      //skip if date field is done
                      var key2 = key.substring(0, len - 1);
                      if (okDates.contains(key2)) continue;

                      //find item
                      item = items.firstWhereOrNull((a) => a.fid == key2);
                      if (item == null) {
                          LogUt.error("no fid = " + key2);
                          return _errorCode;
                      }
                  } else {
                      //else case, skip & log error
                      LogUt.error("no fid = " + prop.key);
                      return _errorCode;
                  }
              }
              //#endregion

              //#region set where & add argument
              var col = StrUt.isEmpty(item.col) ? (table + item.fid) : item.col;
              //2 date fields, fid tail must be 2 !! ex:StartDate, StartDate2
              if (item.type == QitemTypeEnum.date) {
                  //log date2 is done
                  okDates.add(item.fid);

                  //get where
                  var fid2 = item.fid + "2";
                  var hasDate1 = ObjectUt.notEmpty(findJson[item.fid]);
                  var hasDate2 = ObjectUt.notEmpty(findJson[fid2]);
                  if (hasDate1 && hasDate2) {  //case of has 2nd field, then query start/end
                      itemWhere = "($col is Null Or $col Between $item.fid And $fid2)";
                      _addArg(item.fid, DateUt.csToDt(value.toString() + " 00:00:00"));
                      _addArg(fid2, DateUt.csToDt(findJson[fid2].toString() + " 23:59:59"));
                  } else if (hasDate1) { //has start date, then query this date after
                      itemWhere = "($col is Null Or $col >= $item.fid)";

                      //Datetime only read date part, type is string
                      var date1 = DateUt.csToDt(value.toString());
                      _addArg(item.fid, StrUt.getLeft(date1.toString(), " "));
                  } else if (hasDate2) { //has end date, then query this date before
                      itemWhere = "($col is Null Or $col <= $fid2)";

                      //Datetime field only get date part, type is string
                      var date1 = DateUt.csToDt(value.toString());
                      _addArg(fid2, StrUt.getLeft(date1.toString(), " ") + " 23:59:59");
                  }
              }
              //2 date fields, if input one date then must in range, if input 2 dates, then must be intersection with start/end
              //ex: StartDate, EndDate, no consider item.op !!
              else if (item.type == QitemTypeEnum.date2) {
                  //if Date2 field not set "Other", log error & skip
                  var fid2 = item.fid + "2";
                  var col2 = item.other;
                  if (StrUt.isEmpty(col2)) {
                      LogUt.error("no Other field for Date2 (${item.fid})");
                      return _errorCode;
                  }

                  //log date2 is done
                  okDates.add(item.fid);

                  //get where
                  var hasDate1 = ObjectUt.notEmpty(findJson[item.fid]);
                  var hasDate2 = ObjectUt.notEmpty(findJson[fid2]);
                  if (hasDate1 && hasDate2) {  //case of 2nd field, then query start/end
                      itemWhere = "(($col is Null Or $col <= $fid2) And ($col2 is Null Or $col2 >= ${item.fid}))";
                      _addArg(fid2, StrUt.getLeft(DateUt.csToDt(findJson[fid2].toString()).toString(), " ") + " 23:59:59");
                      _addArg(item.fid, StrUt.getLeft(DateUt.csToDt(value.toString()).toString(), " "));
                  } else if (hasDate1) { //only start date, then query bigger than this date
                      itemWhere = "($col2 is Null or $col2 >= ${item.fid})";

                      //get date part of Datetime
                      var date1 = DateUt.csToDt(value.toString());
                      _addArg(item.fid, StrUt.getLeft(date1.toString(), " "));
                  } else if (hasDate2) { //only end date, then query small than this date
                      itemWhere = "($col is Null Or $col <= $fid2)";

                      //get date part of Datetime
                      var date1 = DateUt.csToDt(value.toString());
                      _addArg(fid2, StrUt.getLeft(date1.toString(), " ") + " 23:59:59");
                  }
              } else if (item.op == ItemOpEstr.equal) {
                  itemWhere = col + "=@" + item.fid;
                  _addArg(item.fid, value);
              } else if (item.op == ItemOpEstr.like) {
                  itemWhere = col + " like @" + item.fid;
                  _addArg(item.fid, value + "%");
              } else if (item.op == ItemOpEstr.notLike) {
                  itemWhere = col + " not like @" + item.fid;
                  _addArg(item.fid, value + "%");
              } else if (item.op == ItemOpEstr.in_) {
                  //"in" has different args type !!
                  //change carrier sign to comma for TextArea field
                  var value2 = value.toString().replaceAll(" ", "").replaceAll("\n", ",");
                  var values = value2.split(',');
                  List<String> names = [];
                  for (var i = 0; i < values.length; i++) {
                      if (StrUt.isEmpty(values[i])) continue;

                      var fid = item.fid + i.toString();
                      _addArg(fid, values[i]);
                      names.add("@" + fid);
                  }
                  if (names.isEmpty) continue;

                  itemWhere = col + " in (" + names.join(",") + ")";
              } else if (item.op == ItemOpEstr.like2) {
                  _addArg(item.fid, "%" + value.toString() + "%");
                  itemWhere = col + " Like @" + item.fid;
              } else if (item.op == ItemOpEstr.likeList) {
                  var where2 = "";
                  var or = "";
                  var values = value.toString().replaceAll(" ", "").split(',');
                  for (var i = 0; i < values.length; i++) {
                      if (StrUt.isEmpty(values[i])) continue;

                      var fid = item.fid + i.toString();
                      where2 += or + col + " Like @" + fid;
                      or = " Or ";
                      _addArg(fid, values[i] + "%");
                  }
                  if (where2 == "") continue;

                  itemWhere = "(" + where2 + ")";
              } else if (item.op == ItemOpEstr.likeCols || item.op == ItemOpEstr.like2Cols) {
                  var pre = (item.op == ItemOpEstr.like2Cols) ? "%" : "";
                  var where2 = "";
                  var or = "";
                  var cols = col.replaceAll(" ", "").split(',');
                  for (var col2 in cols) {
                      if (StrUt.isEmpty(col2)) continue;

                      where2 += or + col2 + " Like @" + item.fid;
                      or = " Or ";
                  }
                  if (where2 == "") continue;

                  _addArg(item.fid, pre + value + "%");
                  itemWhere = "(" + where2 + ")";
              } else if (item.op == ItemOpEstr.is_) {
                  if (value.toString() != "1") {
                      itemWhere = col + " is Null";
                  } else if (value.toString() != "0") {
                      itemWhere = col + " is not Null";
                  } else {
                      itemWhere = col + " is " + value;
                  }
              } else if (item.op == ItemOpEstr.isNull) {
                  if (value.toString() != "1") continue;                  
                  itemWhere = col + " is Null";
              } else if (item.op == ItemOpEstr.notNull) {
                  if (value.toString() != "1") continue;
                  itemWhere = col + " is not Null";
              } else if (item.op == ItemOpEstr.userDefined) {
                  itemWhere = "(" + col + " " + value.toString() + ")";
              } else if (item.op == ItemOpEstr.inRange) {
                  var fid2 = item.fid + "2";
                  var hasNum1 = ObjectUt.notEmpty(findJson[item.fid]);
                  var hasNum2 = ObjectUt.notEmpty(findJson[fid2]);

                  okDates.add(item.fid);

                  if (hasNum1 && hasNum2) {
                      itemWhere = "($col >= ${item.fid} And $col <= $fid2)";
                      _addArg(item.fid, value.toString());
                      _addArg(fid2, findJson[fid2].toString());
                  } else if (hasNum1) {
                      itemWhere = "($col >= ${item.fid})";
                      _addArg(item.fid, value.toString());
                  } else if (hasNum2) {
                      itemWhere = "($col <= $fid2)";
                      _addArg(fid2, findJson[fid2].toString());
                  }
              } else {
                  //let it sql wrong!!
                  itemWhere = col + " " + item.op + " @" + item.fid;
                  _addArg(item.fid, value);
              }
              //#endregion

              /*
              //#region consider OrGroups
              var findGroup = -1;
              if (groupLen > 0) {
                  for (var i = 0; i < groupLen; i++) {
                      var group = readDto.OrGroups[i];
                      if (group.Contains(item.fid)) {
                          findGroup = i;
                          break;
                      }
                  }
              }
              */
              //if (findGroup >= 0) {
              //    orWheres[findGroup] += itemWhere + " Or ";
              //} else {
                  where += and + itemWhere;
                  and = " And ";
              //}
              //#endregion
          } //foreach findJson

          /*
          //add orWheres[] into where
          if (groupLen > 0) {
              for (var orWhere in orWheres) {
                  if (StrUt.notEmpty(orWhere)) {
                      where += and + "(" + orWhere[0..^4] + ")";
                      and = " And ";
                  }
              }
          }
          */
      }//if
      //#endregion

      /*
      //#region 2.where add for AuthType=Data if need
      if (_Fun.IsAuthTypeRow()) {
          var baseUser = _Fun.GetBaseUser();
          if (baseUser.UserId == "") return "-2";

          var range = _XgProg.GetAuthRange(baseUser.ProgAuthStrs, ctrl, crudEnum);
          if (range == AuthRangeEnum.User) {
              //by user
              where += and + string.Format(readDto.WhereUserFid, baseUser.UserId);
              and = " And ";
          } else if (range == AuthRangeEnum.Dept) {
              //by depart
              where += and + string.Format(readDto.WhereDeptFid, baseUser.DeptId);
              and = " And ";
          }
      }
      //#endregion

      //#region 3.where add quick search
      //var search = (_dtIn.search == null) ? "" : _dtIn.search.value;
      var search = inputSearch;
      if (StrUt.notEmpty(search)) {
          //by finding string
          itemWhere = "";
          and = "";
          for (var col2 in readDto.findCols) {
              //_stCache.readFids.Add(_list.findCols[i]);
              itemWhere += and + col2 + " Like @" + _FindFid;
              and = " Or ";
          }

          //add where
          itemWhere = "(" + itemWhere + ")";
          if (where == "") {
              where = itemWhere;
          } else {
              where += " And " + itemWhere;
          }

          //add argument
          _addArg(_FindFid, "%" + search + "%");
      }
      //#endregion
      */

      //case of ok
      return where;
      /*
  lab_error:
      await _Log.ErrorAsync("CrudRead.cs GetWhereAsync() failed: " + error);
      return "-1";
      */
  }

  /*
  ///get dataTable json object(Map) for find rows at backend
  ///@findJson find json string
  ///@return dataTable json
  DtDto getDtJson([String findJson = '']) {
    return DtDto(
      start: (_nowPage - 1) * _pageRows,
      length: _pageRows,
      recordsFiltered: _rowCount,
      findJson: findJson,
    );
  }
  */

} //class
