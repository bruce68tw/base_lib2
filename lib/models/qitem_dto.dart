import '../enums/all.dart';

class QitemDto {

  //client field id
  String fid;

  //column id, has table alias
  String col;

  //where operator
  String op = ItemOpEstr.equal;

  //query field data type
  int type = QitemTypeEnum.none;        

  //other info, when Type=Date2, Other=another Date Col, ex: ShowEnd/u.ShowEnd
  String other;


  QitemDto({this.fid = '', this.col = '', this.op = ItemOpEstr.equal, 
    this.type = QitemTypeEnum.none, this.other = ''});

}