
import 'package:collection/collection.dart';  //for firstWhereOrNull
import '../models/id_str_dto.dart';
import '../models/id_str2_dto.dart';
import 'fun_ut.dart';
import 'str_ut.dart';

class ListUt {

  //json to string
  static String toStr(List<String>? list) {
    return (list == null)
      ? '' : list.join(',');
  }

  static void selectAddEmpty(List<IdStrDto> rows) {
    rows.insert(0, IdStrDto(id: '', str: FunUt.select));
  }

  static String firstId(List<IdStrDto> rows) {
    return rows.isEmpty 
      ? ''
      : rows.first.id;
  }

  //return -1 if not found
  static int findStr(List<String> rows, String? find) {
    return rows.indexWhere((a)=> a == find);
  }

  static String findOrFirst(List<IdStrDto> rows, String? find) {
    var find2 = (find == null) ? '' : find.toString();
    return StrUt.isEmpty(find2) ? firstId(rows) :
      rows.any((a)=> a.id == find2) ? find2 : 
      firstId(rows);
  }

  static String? findValue(List<IdStrDto> rows, String find) {
    var row = rows.firstWhereOrNull((a)=> a.id == find);
    return (row == null)
      ? null : row.str;
  }

  //dart toSet() 無法 distinct, 自行coding
  static List<IdStrDto> distinct(List<IdStrDto> rows) {
    List<String> ids = [];
    List<IdStrDto> data = [];
    for(var row in rows){
      if (!ids.contains(row.id)){
        ids.add(row.id);
        data.add(row);
      }
    }    
    return data;
  }

  static List<IdStrDto> filter(List<IdStr2Dto> rows, String ext) {
    return rows.where((a) => a.ext == ext)
      .map((a)=> IdStrDto (
        id: a.id,
        str: a.str,
      ))
      .toList();
  }

} //class
