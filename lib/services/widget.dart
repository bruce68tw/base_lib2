import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/all.dart';
import 'all.dart';

//static class
class WG {


  static AppBar appBar(String title) {
    return AppBar(title: Text(title));
  }

  /// get text widget
  /// color: for status=true only
  static Text getText(String text, {bool status = true, Color? color}) {
    return Text(text, style:textStyle(status:status, color:color));
  }

  static Text getRedText(String text) {
    return Text(text, style:textStyle(color: Colors.red));
  }

  /// get text widget with label style
  static Text getLabel(String? label, { Color? color }) {
    return Text(label ?? '', style: (color == null) 
      ? FunUt.labelStyle
      : TextStyle(
        fontSize: FunUt.fontSize,
        color: color
      ));
  }

  static Text getRedLabel(String label) {
    return getLabel(label, color: Colors.red);
  }

  /*
  /// get label with color
  static Text getLabel2(String label, Color color) {
    return Text(label, style:TextStyle(
      fontSize: FunUt.fontSize,
      color: color
    ));    
  }
  */

  static Widget centerText(String text) {
    return Center(
      child: Text(text, style:textStyle())
    );
  }

  ///display label & text
  static Widget labelText(String label, String text, [Widget? divider]) {
    var isHori = (divider == null);
    var list = <Widget>[
        getLabel(label),
        getText(text),
    ];
    if (!isHori) list.add(divider);

    return isHori
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        );
  }

  ///input field style, consider status
  static TextStyle textStyle({bool status = true, Color? color}) {    
    return TextStyle(
      color: !status ? FunUt.textColorRead : 
        (color == null) ? FunUt.textColorEdit : color,
      fontSize: FunUt.fontSize,
    );
  }

  //return label
  static InputDecoration inputDecore(String label) {
    var errorStyle = TextStyle(
      fontSize: FunUt.errorFontSize,
    );
    return InputDecoration(
      errorStyle: errorStyle
    );
  }

  ///gap for padding or margin
  static EdgeInsets gap(double pixel) {
    return EdgeInsets.all(pixel);
  }

  /*
  static Widget gap2([double width = 5]) {
    return SizedBox(width: width);
  }
  */

  /// get divider for list view
  /// @height line height
  static Divider divider(double height) {
    return Divider(height: height, thickness: 1);
  }

  static Widget emptyMsg(String msg, double fontSize, Color color){
    return Center(child: Text(msg, 
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      )));
  }

  ///link button
  ///VoidCallback is need, onPressed on ()=> before function !!
  //static Widget textBtn(String text, [VoidCallback? fnOnClick]) {
  static Widget textBtn(String text, [Function? fnOnClick]) {
    //var status = (fnOnClick != null);
    //var color = status
    //  ? Colors.blue : Colors.grey;
    return TextButton(
      onPressed: (fnOnClick == null) ? null : ()=> fnOnClick(),
      child: Text(text),
    ); 
  }

  ///create TextButton
  ///VoidCallback is need, onPressed on ()=> before function !!
  //static Widget elevBtn(String text, [VoidCallback? fnOnClick]) {
  static Widget elevBtn(String text, [Function? fnOnClick, Color? fontColor, Color? bgColor]) {
    //var status = (fnOnClick != null);
    //var color = status
    //  ? Colors.blue : Colors.grey;
    return ElevatedButton(
      onPressed: (fnOnClick == null) ? null : ()=>fnOnClick(),
      style: (bgColor == null) 
        ? null 
        : ElevatedButton.styleFrom( foregroundColor: fontColor, backgroundColor: bgColor),
      child: Text(text)
    ); 
  }

  /// center ElevatedButton
  //static Widget centerElevBtn(String label, [VoidCallback? fnOnClick]) {
  static Widget centerElevBtn(String label, [Function? fnOnClick, Color? fontColor, Color? bgColor]) {
    return Center(child: WG.elevBtn(label, fnOnClick, fontColor, bgColor));
  }

  ///create TextButton
  ///VoidCallback is need, onPressed on ()=> before function !!
  //static Widget tailElevBtn(String text, [VoidCallback? fnOnClick]) {
  static Widget tailElevBtn(String text, [Function? fnOnClick]) {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: elevBtn(text, fnOnClick)
      )
    );
  }

  /*
  /// tableRow with label string & widget
  static TableRow tableLabelWidget(String label, Widget widget){
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: WG.getLabel(label)
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: widget
      )
    ]);
  }
  */

  /// tableRow with 2 widgets
  /// //param lowHeight: null(不設定高度, 系統預設),true(最小高度),false(系統指定高度(可改變))
  static TableRow tableRow2(String label, Widget input, 
    {bool required = false, bool setHeight = true}){

    return TableRow(children: [
      if (setHeight)...[
        //設定最小高度
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,   //work !!
          child: reqLabel(label, required)
          /*
          child: ConstrainedBox(
            constraints: BoxConstraints( minHeight: FunUt.fieldHeight ),
            child: reqLabel(label, required)
        )*/),
        TableCell(
          //verticalAlignment: TableCellVerticalAlignment.top,  //not work !!
          child: ConstrainedBox(
            constraints: BoxConstraints( minHeight: FunUt.fieldHeight ),
            child: input
        ))
      ] else...[
        TableCell( child: reqLabel(label, required)),
        TableCell( child: input )
      ] 
    ]);
  }

  /// required label
  static Widget reqLabel(String label, [bool required = true]){
    return required
      ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.end, //使用center位置會往下掉!!
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getLabel(label),
            getRedLabel('*'),
          ]
        )
      : getLabel(label);
  }

  static TableRow ilabel2(String label, [String? text]){
    return tableRow2(label, getLabel(text));
  }

  static Widget itext(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isPwd = false, /*String? initValue,*/
    Function? fnValid, Function? fnOnChange}){
    
    return _textWidget(label, ctrl,  
      status: status, required: required, maxLines:maxLines, 
      isPwd: isPwd, /*initValue: initValue,*/
      fnValid: fnValid, fnOnChange:fnOnChange);
  }

  static TableRow itext2(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isPwd = false, /*String? initValue,*/
    Function? fnValid, Function? fnOnChange}){

    return tableRow2(label, itext('', ctrl, status: status, required: required, maxLines: maxLines, 
        /*initValue: initValue,*/ isPwd: isPwd, fnValid: fnValid, fnOnChange: fnOnChange),
      required: required);
  }

  static Widget inum(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isDecimal = false, bool canZero = false, 
    Function? fnValid, Function? fnOnChange}){
    
    return _textWidget(label, ctrl,  
      status: status, required: required, maxLines:maxLines, 
      isDecimal: isDecimal, canZero: canZero, isPwd: false, 
      fnValid: fnValid, fnOnChange:fnOnChange);
  }

  static TableRow inum2(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isDecimal = false, bool canZero = false,
    Function? fnValid, Function? fnOnChange}){

    return tableRow2(label, inum('', ctrl, status: status, required: required, maxLines: maxLines, 
        isDecimal: isDecimal, canZero: canZero, fnValid: fnValid, fnOnChange: fnOnChange),
      required: required);
  }

  //=== input field below ===
  /// @param isDecimal: null(文字),true(小數),false(整數)
  /// @param canZero: (for num only)
  /// @param isPwd: (for text only)
  static Widget _textWidget(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, /*String? initValue,*/
    bool? isDecimal, bool canZero = false, bool isPwd = false, 
    Function? fnValid, Function? fnOnChange}){
        
    //if (StrUt.notEmpty(initValue)){
    //  ctrl.text = initValue!;
    //}
    return TextFormField(
      controller: ctrl,
      //textAlignVertical: TextAlignVertical.center,
      //initialValue: initValue,
      keyboardType: (isDecimal == null) ? TextInputType.text : 
        TextInputType.numberWithOptions(decimal: isDecimal),
        //TextInputType.number,
      inputFormatters: (isDecimal == null) ? null :
        isDecimal ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,-]'))] : 
        [FilteringTextInputFormatter.allow(RegExp('[0-9,-]'))],
        //[FilteringTextInputFormatter.digitsOnly],

      readOnly: !status,
      style: textStyle(status: status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      //decoration: inputDecore(label),
      decoration: const InputDecoration(
        //isDense: true,
        //hasFloatingPlaceholder: true,
        //labelText: 'Select Contact Name',
        //contentPadding: EdgeInsets.symmetric(vertical: 5),
        contentPadding: EdgeInsets.only(bottom: 8),
      ),
      minLines: 1,
      maxLines: maxLines,

      //for password input
      obscureText: isPwd,
      enableSuggestions: !isPwd,
      autocorrect: !isPwd,

      onChanged: (value){
        (fnOnChange == null) ? null : fnOnChange(value);          
      },
      validator: (value) {
        //flutter判斷式會全部檢查, 必須分開
        var isEmpty = StrUt.isEmpty(value);
        if (isEmpty){
          return required
            ? FunUt.notEmpty : null;
        } 

        /*
        if (isDecimal != null && !canZero && !isEmpty){
          if ((isDecimal && double.parse(value!) == 0) || (!isDecimal && int.parse(value!) == 0 )){
            return FunUt.notZero;
          }
        }
        */
        if (isDecimal != null){
          if ((isDecimal && double.tryParse(value!) == null) || (!isDecimal && int.tryParse(value!) == null)){
            return FunUt.onlyNum;
          }
        }

        return (fnValid == null) ? null : 
          fnValid(value);          
      },
    );
  }

  /// select option(dropdown)
  /// DropdownButtonFormField 才有 validate, DropdownButton 沒有
  static Widget iselect(String label, dynamic value, List<IdStrDto> rows, Function? fnOnChange,
    {bool status = true, bool required = false, Function? fnValid}){

    var value2 = rows.isEmpty ? '' :
      ListUt.findOrFirst(rows, value.toString());

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value2,
      style: textStyle(status: status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      //decoration: inputDecore(label),
      decoration: const InputDecoration(
        //isDense: true,
        //hasFloatingPlaceholder: true,
        //labelText: 'Select Contact Name',
        //contentPadding: EdgeInsets.symmetric(vertical: 5),
        contentPadding: EdgeInsets.only(bottom: 4),
      ),
      items: rows.map((IdStrDto row) {
        return DropdownMenuItem<String>(
          value: row.id,
          child: Text((row.str == '') ? row.id : row.str),
        );
      }).toList(),
      onChanged: (status && fnOnChange != null)
        ? (value2)=> fnOnChange(value2)
        : null,
      validator: (value2) {
        return (required && StrUt.isEmpty(value2)) ? FunUt.notEmpty :
          (fnValid == null) ? null : 
          fnValid(value2);          
    });
  }

  static TableRow iselect2(String label, dynamic value, List<IdStrDto> rows, Function? fnOnChange,
    {bool status = true, bool required = false, Function? fnValid}){

    return tableRow2(label, iselect('', value, rows, fnOnChange, status:status, 
      required:required, fnValid:fnValid), 
      required: required);
  }

  /// date input
  /// fnOnChange : must be (value)=>
  static Widget idate(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, 
    bool oneYearRange = true, bool setNow = true}){

    var days = oneYearRange ? 356 : 36500;
    var today = DateTime.now();
    //日期字串如果不正確會error, 所以先做檢查
    //if (setNow && StrUt.isEmpty(ctrl.text)) ctrl.text = DateUt.toDateStr(today);
    DateUt.setCtrlText(ctrl, setNow);
    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status: status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      decoration: inputDecore(label),
      onTap: status
        ? () async {
          //_nowDate = value;
          // Below line stops keyboard from appearing
          FocusScope.of(context).requestFocus(FocusNode());
          // Show Date Picker Here
          //await _openDate(context);
          final DateTime? date = await showDatePicker(
            context: context,
            initialDate: StrUt.isEmpty(ctrl.text) 
              ? DateTime.now() : DateUt.csToDt(ctrl.text)!,
            firstDate: today.add(Duration(days: (-1) * days)), 
            lastDate: today.add(Duration(days: days)),
          );

          if (date != null) {
            ctrl.text = DateFormat(DateUt.dateCsFormat).format(date);
            fnOnChange(date);
          }

          //ctrl.text = DateFormat('yyyy/MM/dd').format(_nowDate);
          //setState(() {});
        }
        : null,
        
      validator: (value) {
        var isEmpty = StrUt.isEmpty(value);
        return (required && isEmpty) ? FunUt.notEmpty : null;
      },

    );
  }

  static TableRow idate2(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, 
    bool oneYearRange = true, bool setNow = true}){

    return tableRow2(label, idate(context, '', ctrl, fnOnChange, status:status, 
      required:required, oneYearRange:oneYearRange,
      setNow: setNow), 
      required: required);
  }

  /// hour minutes
  static Widget itime(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, 
    {bool status = true, bool required = false,
    bool setNow = true}){

    //var now = DateTime.now();
    late TimeOfDay value;
    if (StrUt.isEmpty(ctrl.text)){
      value = TimeOfDay.now();
      if (setNow) ctrl.text = DateUt.toTimeStr(DateTime.now());
    } else {
      value = DateUt.strToTime(ctrl.text);
    }

    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status: status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      decoration: inputDecore(label),
      onTap: status
        ? () async {
          //TimeOfDay.now()
          final time = await showTimePicker(
            context: context, 
            initialTime: value
          );

          if (time != null) ctrl.text = DateUt.timeToStr(time);

          //callback
          fnCallback(time);
        }
        : null,
      validator: (value) {
        var isEmpty = StrUt.isEmpty(value);
        return (required && isEmpty) ? FunUt.notEmpty : null;
      },

    );
  }

  static TableRow itime2(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, 
    {bool status = true, bool required = false,
    bool setNow = true}){

    return tableRow2(label, itime(context, '', ctrl, fnCallback, status: status, 
        required:required, setNow:setNow), 
      required: required);
  }

  /// checkbox, 裡面使用sizeBox會很不好點擊 !1 
  /// fnOnChange : must (value){} !!
  static Widget icheck(String label, bool checked, Function fnOnChange, 
    {bool status = true, bool center = false, Color? labelColor}) {

    return Row(
      mainAxisAlignment: center
        ? MainAxisAlignment.center
        : MainAxisAlignment.start,
      children: [     
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 0, left:0),
          child: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              //checkColor: Colors.white,
              //fillColor: MaterialStateProperty.resolveWith(getColor),
              value: checked,
              materialTapTargetSize: MaterialTapTargetSize.padded,  //增加點擊範圍
              onChanged: (bool? value) {
                fnOnChange(value);        
        }))),
        getText(label, status: status, color: labelColor),
    ]);
  }

  //text: checkbox tail text
  static TableRow icheck2(String label, bool checked, Function fnOnChange, 
    {bool status = true, String text = ''}) {

    return tableRow2(label, icheck(text, checked, fnOnChange, status:status));
  }

  static Widget iradio(List<dynamic> labelValues, dynamic value, Function fnOnChange, 
    {bool status = true, bool isCenter = false}) {

    List<Widget> widgets = [];
    for(var i=0; i<labelValues.length; i+=2){
      widgets.add(Radio<dynamic>(
        value: labelValues[i+1],
        groupValue: value,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,  //縮小間隔
        onChanged: (val)=> fnOnChange(val)
      ));
      widgets.add(WG.getText(labelValues[i], status: status));
    }

    return Row(
      mainAxisAlignment: isCenter
        ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: widgets
    );    
  }

  static TableRow iradio2(String label, List<dynamic> labelValues, dynamic value, Function fnOnChange, 
    {bool status = true, bool isCenter = false}) {

    return tableRow2(label, iradio(labelValues, value, fnOnChange, status:status, isCenter: isCenter));
  }

  //vertical gap
  static Widget vGap([double value = 10]){
    return SizedBox(height: value);
  }

  //horizontal gap
  static Widget hGap([double value = 5]){
    return SizedBox(width: value);
  }

  //vertical expand
  static Widget vExpand(){
    return const Expanded(
      child: Text('')
    );
  }

} //class
