import 'id_str_dto.dart';

class IdStr2Dto extends IdStrDto {
  //String id;
  //String str;
  String ext;

  IdStr2Dto({required String id, required String str, required this.ext}) : super(id:id, str:str);

  ///convert json to model, static for be parameter !!
  static IdStr2Dto fromJson(Map json){
    return IdStr2Dto(
      id : json['Id'],
      str : json['Str'] ?? '',
      ext : json['Ext'] ?? '',
    );
  }

}