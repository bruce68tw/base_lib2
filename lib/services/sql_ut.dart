import '../models/all.dart';
import 'str_ut.dart';

class SqlUt {

  //static const _sql = "select {0} {1} limit {2},{3}";

  //convert sql string to model 
  static SqlDto? sqlToDto(String sql, bool useSquare){
    //return SqlDto();

    if (StrUt.isEmpty(sql)) return null;

    var sql2 = sql.toLowerCase();
    var len = sql2.length;
    int from, where, group, order;
    if (useSquare) {
        from = sql2.indexOf("[from]");
        where = sql2.indexOf("[where]");
        group = sql2.indexOf("[group]");
        order = sql2.indexOf("[order]");
    } else {
        from = sql2.indexOf("from ");
        where = sql2.indexOf("where ");
        group = sql2.indexOf("group ");
        order = sql2.indexOf("order ");
    }

    var end = len;
    var result = SqlDto();
    if (order < 0){
        result.order = "";
    } else {
        result.order = useSquare 
          ? "Order " + sql.substring(order + 7).trim() 
          : sql.substring(order).trim();
        end = order - 1;
    }

    if (group < 0){
        result.group = "";
    } else {
        result.group = useSquare 
          ? "Group " + sql.substring(group + 7, end).trim() 
          : sql.substring(group, end).trim();
        end = group - 1;
    }

    if (where < 0){
        result.where = "";
    } else {
        result.where = useSquare 
          ? "Where " + sql.substring(where + 7, end).trim() 
          : sql.substring(where, end).trim();
        end = where - 1;
    }

    if (useSquare) {
        result.from = "From " + sql.substring(from + 6, end).trim();
        result.select = sql..substring(0, from).trim()..substring(7);     //exclude "Select" word !!
    } else {
        result.from = sql.substring(from, end).trim();
        result.select = sql.substring(0, from).trim().substring(7);     //exclude "Select" word !!
    }

    //set columns[]
    result.columns = result.select.split(',');
    for (var i=0; i<result.columns!.length; i++)
    {
        var col = result.columns![i].trim();
        var pos = col.indexOf(" ");
        result.columns![i] = (pos > 0) ? col.substring(0, pos) : col;
    }
    return result;
  }

  static String dtoToSql(SqlDto dto, int start, int length){
    var group = (dto.group == "") ? "" : " ${dto.group}";
    var sql = "${dto.select} ${dto.from} ${dto.where}$group";
    var result = "select $sql ${dto.order} limit $start,$length";
    return result.replaceAll("  ", " ");
  }

} //class
