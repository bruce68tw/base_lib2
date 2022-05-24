import 'package:flutter/material.dart';
import '../models/all.dart';

//pager service
class PagerSrv {
  //constant
  static const first = 'F';
  static const prev = 'P';
  static const next = 'N';
  static const last = 'L';

  //static const EdgeInsets BtnGap = const EdgeInsets.all(5);

  //#region input parameters
  ///action for read rows
  late Function _fnOnClick;

  ///rows count per page
  late int _pageRows;

  ///numeric button count
  late int _numBtns;

  ///show '[x]pages' or not
  //late bool _showTotalPages;
  //#endregion

  //#region instance variables
  ///now page no, base 1
  int _nowPage = -1; //-1 for checking in setPageVar()
  ///filtered rows conut, -1 mean
  late int _rowCount;

  ///total pages by _totalRows
  late int _totalPages;

  ///first page no of form
  late int _firstPage;

  ///first page no max value
  late int _firstMax;

  ///last page no of form
  late int _lastPage;

  ///text enabled color
  late Color _textColor;
  ///text disabled color
  late Color _textDisColor;
  //late Color _textNowColor;

  late Color _btnBgColor;
  late TextStyle _textStyle;
  late TextStyle _textNowStyle;
  //#endregion

  ///constructor
  PagerSrv(Function fnOnClick,
      {int pageRows = 5,
      int numBtns = 5,
      //bool showTotalPages = false,
      double fontSize = 15,
      Color textColor = Colors.black,
      Color textDisColor = Colors.grey,
      Color textNowColor = Colors.white,
      Color btnBgColor = Colors.blue}) {

    _fnOnClick = fnOnClick;
    _pageRows = pageRows;
    _numBtns = numBtns;
    //_showTotalPages = showTotalPages;

    _textColor = textColor;
    _textDisColor = textDisColor;
    //_textNowColor = textNowColor;
    _btnBgColor = btnBgColor;

    _textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
    _textNowStyle = TextStyle(
      fontSize: fontSize,
      color: textNowColor,
    );

    _reset();
  }

  /*
  ///show pager or not
  bool isShow() {
    return (_totalRows > 0);
  }
  */

  ///get dataTable json object(Map) for find rows at backend
  ///@findJson find json string
  ///@return dataTable json
  DtDto getDtJson([String findJson = '']) {
    return DtDto(
      start: (_nowPage - 1) * _pageRows,
      length: _pageRows,
      recordsFiltered: _rowCount,
      findJson: findJson,
    );
  }

  Widget getWidgetByDto(PagerDto pagerDto) {
    return getWidget(pagerDto.recordsFiltered);
  }

  Widget getWidget(int rowCount) {
    if (rowCount <= 0) return Container();
    
    _setTotalRows(rowCount);
    //temp remark
    //add '[x]pages' if need
    //var result = Row();
    /*
    var widgets = <Widget>[];
    if (widget.showTotalPages){
      var hasRes = _totalRows % widget.pageRows > 0;
      var totalPages = _totalRows ~/ widget.pageRows + (hasRes ? 1 : 0);
      widgets.add(Text('{$totalPages}pages', style: _textStyle));
    }
    TextButton.styleFrom(
      backgroundColor: colorScheme.primary,
      shape: CircleBorder(),
    )    
    */

    //1.add first 2 buttons
    var btns = <Widget>[];
    var showFun = (_totalPages > _numBtns);
    bool status;
    if (showFun) {
      status = (_firstPage > 1);
      btns.add(_getButton(first, _getIcon(Icons.skip_previous, status), status));
      btns.add(_getButton(prev, _getIcon(Icons.navigate_before, status), status));
    }

    //2.add num buttons
    for (var i = _firstPage; i <= _lastPage; i++) {
      var fun = i.toString();
      btns.add((i == _nowPage)
          ? _getButton(fun, Text(fun, style: _textNowStyle), true, _btnBgColor)
          : _getButton(fun, Text(fun, style: _textStyle), true));
    }

    //3.add last 2 buttons
    if (showFun) {
      status = (_lastPage < _totalPages);
      btns.add(_getButton(next, _getIcon(Icons.navigate_next, status), status));
      btns.add(_getButton(last, _getIcon(Icons.skip_next, status), status));
    }

    //4.return widget
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: btns,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ));
  }

  ///set totalRows
  void _setTotalRows(int rowCount) {
    //check
    if (rowCount == _rowCount) return;

    _rowCount = rowCount;
    _totalPages = (_rowCount <= 0)
        ? 0
        : (_rowCount ~/ _pageRows) + (_rowCount % _pageRows > 0 ? 1 : 0);

    _firstMax = _totalPages - _numBtns + 1;
    if (_firstMax < 1) _firstMax = 1;

    _setPageVar();
  }

  void _reset() {
    _rowCount = -1; //for recount
    _totalPages = 0;
    _setPageVar(first);
  }

  ///return pager widget
  Icon _getIcon(IconData name, bool status) {
    return Icon(
      name,
      size: 20,
      color: status ? _textColor : _textDisColor,
    );
  }

  CircleAvatar _getButton(String fun, Widget icon, bool status,
      [Color? bgColor]) {
    return CircleAvatar(
      radius: 17,
      backgroundColor: (bgColor == null) ? Colors.transparent : bgColor,
      child: IconButton(
        icon: icon,
        onPressed: () => status ? _onClick(fun) : null,
      ),
    );
  }

  ///set nowPage, firstPage, lastPage
  ///@fun fun type, default to nowPage
  ///@return nowPage is changed or not
  bool _setPageVar([String fun = '']) {
    if (fun == '') fun = _nowPage.toString();

    var nowPage = _nowPage;
    switch (fun) {
      case first:
        _nowPage = 1;
        _firstPage = 1;
        break;
      case prev:
        _firstPage -= _numBtns;
        if (_firstPage < 1) _firstPage = 1;
        _nowPage = _firstPage + _numBtns - 1;
        if (_nowPage >= nowPage) _nowPage = nowPage - 1;
        break;
      case next:
        _firstPage += _numBtns;
        if (_firstPage > _firstMax) _firstPage = _firstMax;
        _nowPage = _firstPage;
        if (_nowPage <= nowPage) _nowPage = nowPage + 1;
        break;
      case last:
        _nowPage = _totalPages;
        _firstPage = _firstMax;
        break;
      default:
        _nowPage = int.parse(fun);
        //firstPage did not change here !!
        break;
    }

    _lastPage = _firstPage + _numBtns - 1;
    if (_lastPage > _totalPages) _lastPage = _totalPages;

    return (nowPage != _nowPage);
  }

  void _onClick(String fun) {
    if (_setPageVar(fun)) _fnOnClick();
  }

} //class
