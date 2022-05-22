
class PageUt {

  //int(0/1) to boolean
  static bool toBool(int? value) {
    return (value != null && value > 0);
  }

  static int getPageRows(int pageRows, {List<int>? pageRowList})
  {
      pageRowList ??= [ 10, 25, 50, 100 ];
      return pageRowList.contains(pageRows) ? pageRows : 
        (pageRows < pageRowList[0]) ? pageRows : 
        pageRowList[0];
  }

} //class
