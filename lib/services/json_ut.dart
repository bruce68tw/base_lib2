import 'dart:convert';
import '../models/id_str2_dto.dart';
import '../models/id_str_dto.dart';
import 'fun_ut.dart';

//static class
class JsonUt {

  //json to string
  static String toStr(Map json) {
    return jsonEncode(json);
  }

  //List<json> to List<IdNameDto>
  //return not null rows for easy coding !!
  static List<IdStrDto> rowsToIdStrs(List? rows) {
    return rowsToModels<IdStrDto>(rows, IdStrDto.fromJson) ?? [];
    //return rows ?? [];
  }
  static List<IdStr2Dto> rowsToIdStrs2(List? rows) {
    return rowsToModels<IdStr2Dto>(rows, IdStr2Dto.fromJson) ?? [];
    //return rows ?? [];
  }

  //jsons to model list
  static List<T>? rowsToModels<T>(List? list, Function fromJson) {
    return (list == null)
      ? null
      : list.map((row) => fromJson(row)).cast<T>().toList(); //has cast<>
  }

  /// find json list by fid & value
  static int find(List<Map>? list, String fid, dynamic value) {
    if (list != null){
      for (var i=0; i<list.length; i++){
        if (list[i][fid] != null && list[i][fid] == value){
          return i;
        }
      }
    }

    //case of not found
    return -1;
  }

  /// find json list by fid & value pairs
  static int find2(List<Map>? list, List<String> fids, List<dynamic> values) {
    if (list != null){
      var len = fids.length;
      for (var i=0; i<list.length; i++){
        var item = list[i];
        for (var j=0; j<len; j++){
          var fid = fids[j];
          var value = values[j];
          if (item[fid] != null && item[fid] == value){
            return i;
          }
        }
      }
    }

    //case of not found
    return -1;
  }

  /// convert Map<String, dynamic> to Map<String, String>
  static Map<String, String>? dynamicToStr(Map<String, dynamic>? json) {
    return (json == null)
      ? null
      : json.map((key, value) => MapEntry(key, value.toString()));
  }

  static Map<String, dynamic> getError({String? error}) {
      return {"ErrorMsg": error ?? FunUt.systemError};
  }

}//class
