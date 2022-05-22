/// datatables dto
class DtDto {
  int start;
  int length;
  int recordsFiltered;
  String findJson;
  //String search;

  DtDto({this.start = 0, this.length = 10, this.recordsFiltered = -1, 
    this.findJson = ''});

}