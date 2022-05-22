class SqlDto {
  //sql statement without "Select" key word
  String select;

  //column list
  List<String>? columns;

  String from;
  String where;
  String group;
  String order;

  SqlDto({this.select = '', this.columns, this.from = '', 
    this.where = '', this.group = '', this.order = ''});

}