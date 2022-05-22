import 'qitem_dto.dart';

class ReadDto {

  /// same as DbReadModel.ColList
  String colList = "";

  /// sql String, column select order must same to client side for datatable sorting !!
  String readSql = "";

  /// sql use square, as: [from],[where],[group],[order]
  /// (TODO: add [whereCond] for client condition !!)
  bool useSquare = false;

  /// default table alias name
  String tableAs = "";

  /// for quick search, include table alias, will get like xx% query
  List<String>? findCols;

  /// query condition fields
  List<QitemDto>? items;


  ReadDto({this.colList = '', this.readSql = '', this.useSquare = false, 
    this.tableAs = '', this.findCols, this.items});

}