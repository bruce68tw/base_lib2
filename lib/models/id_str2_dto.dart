class IdStr2Dto {
  String id;
  String str;
  String ext;

  IdStr2Dto({required this.id, required this.str, required this.ext});

  ///convert json to model, static for be parameter !!
  static IdStr2Dto fromJson(Map json){
    return IdStr2Dto(
      id : json['Id'],
      str : json['Str'],
      ext : json['Ext'],
    );
  }

}