class IdStrDto {
  String id;
  String str;

  IdStrDto({required this.id, required this.str});

  ///convert json to model, static for be parameter !!
  static IdStrDto fromJson(Map json){
    return IdStrDto(
      id : json['Id'].toString(), //may be int
      str : json['Str'],
    );
  }

}