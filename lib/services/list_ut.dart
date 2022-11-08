
//static class
import '../models/id_str_dto.dart';
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

  static String missOrFirst(List<IdStrDto> rows, dynamic find) {
    var find2 = (find == null) ? '' : find.toString();
    return StrUt.isEmpty(find2) ? firstId(rows) :
      rows.any((a)=> a.id == find2) ? find2 : 
      firstId(rows);
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

} //class
