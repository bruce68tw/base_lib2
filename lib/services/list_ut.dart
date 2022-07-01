
//static class
import '../models/id_str_dto.dart';
import 'fun_ut.dart';

class ListUt {

  //json to string
  static String toStr(List<String>? list) {
    return (list == null)
      ? '' : list.join(',');
  }

  static void selectAddEmpty(List<IdStrDto> rows) {
    rows.insert(0, IdStrDto(id: '', str: FunUt.select));
  }

} //class
