import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/all.dart';
import 'all.dart';

//static class
class WG {

  //get text widget
  //color: for status=true only
  static Text getText(String text, [bool status = true, Color? color]) {
    return Text(text, style:textStyle(status, color));
  }

  /// get text widget with label style
  static Text getLabel(String? label) {
    return Text(label ?? '', style:FunUt.labelStyle);
  }

  /// get label with color
  static Text getLabel2(String label, Color color) {
    return Text(label, style:TextStyle(
      fontSize: FunUt.fontSize,
      color: color
    ));    
  }

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
  static TextStyle textStyle([bool status = true, Color? color]) {    
    return TextStyle(
      color: !status ? FunUt.textColorRead : 
        (color == null) ? FunUt.textColorEdit : color,
      fontSize: FunUt.fontSize,
    );
  }

  //return label
  static InputDecoration inputDecore(String label, [bool? lowHeight]) {
    var errorStyle = TextStyle(
      fontSize: FunUt.errorFontSize,
    );
    if (lowHeight == null){
      return InputDecoration(
        errorStyle: errorStyle
      );
    } else {
      return lowHeight
        ? InputDecoration(
            //labelText: label,
            //labelStyle: FunUt.decoreStyle,
            isDense: true,
            errorStyle: errorStyle,
            contentPadding: const EdgeInsets.symmetric(vertical: 5))
        : InputDecoration(
            //labelText: label,
            //labelStyle: FunUt.decoreStyle),
            //isDense: true,
            //contentPadding: EdgeInsets.symmetric(vertical: 5)
            errorStyle: errorStyle
            );
    }
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
      child: Text(text),
      onPressed: (fnOnClick == null) ? null : ()=> fnOnClick(),
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
      child: Text(text),
      onPressed: (fnOnClick == null) ? null : ()=>fnOnClick(),
      style: (bgColor == null) 
        ? null 
        : ElevatedButton.styleFrom( foregroundColor: fontColor, backgroundColor: bgColor)
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
  /// param lowHeight: null(不設定高度, 系統預設),true(最小高度),false(設定正常高度)
  static TableRow tableRow2(String label, Widget input, 
    {bool required = false, bool? lowHeight}){

    if (lowHeight == null){
      return TableRow(children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: reqLabel(label, required)),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: input
      )]);
    } else {
      var height = lowHeight ? FunUt.fieldHeightLow : FunUt.fieldHeight;
      return TableRow(children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: SizedBox(
            child: reqLabel(label, required), 
            height: height
        )),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: SizedBox(
            child: input, 
            height: height
      ))]);
    }
  }

  /// required label
  static Widget reqLabel(String label, [bool required = true]){
    return required
      ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.end, //使用center位置會往下掉!!
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getLabel2('*', Colors.red),
            getLabel(label),
          ]
        )
      : getLabel(label);
  }

  static TableRow ilabel2(String label, [String? text, bool? lowHeight = false]){
    return tableRow2(label, getLabel(text), lowHeight: lowHeight);
  }

  static Widget itext(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isPwd = false, bool? lowHeight, String? initValue,
    Function? fnValid, Function? fnOnChange}){
    
    return _textWidget(label, ctrl,  
      status: status, required: required, maxLines:maxLines, 
      isPwd: isPwd, lowHeight: lowHeight, initValue: initValue,
      fnValid: fnValid, fnOnChange:fnOnChange);
  }

  static TableRow itext2(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isPwd = false, bool? lowHeight, String? initValue,
    Function? fnValid, Function? fnOnChange}){

    return tableRow2(label, itext('', ctrl, status: status, required: required, maxLines: maxLines, 
        initValue: initValue, isPwd: isPwd, lowHeight:lowHeight, fnValid: fnValid, fnOnChange: fnOnChange),
      required: required, lowHeight: lowHeight);
  }

  static Widget inum(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isDecimal = false, bool canZero = false, bool? lowHeight, 
    Function? fnValid, Function? fnOnChange}){
    
    return _textWidget(label, ctrl,  
      status: status, required: required, maxLines:maxLines, 
      isDecimal: isDecimal, canZero: canZero, isPwd: false, lowHeight: lowHeight, 
      fnValid: fnValid, fnOnChange:fnOnChange);
  }

  static TableRow inum2(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, 
    bool isDecimal = false, bool canZero = false, bool? lowHeight, 
    Function? fnValid, Function? fnOnChange}){

    return tableRow2(label, inum('', ctrl, status: status, required: required, maxLines: maxLines, 
        isDecimal: isDecimal, canZero: canZero, lowHeight:lowHeight, fnValid: fnValid, fnOnChange: fnOnChange),
      required: required, lowHeight: lowHeight);
  }

  //=== input field below ===
  /// @param isDecimal: null(文字),true(小數),false(整數)
  /// @param canZero: (for num only)
  /// @param isPwd: (for text only)
  static Widget _textWidget(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, String? initValue,
    bool? isDecimal, bool canZero = false, bool isPwd = false, bool? lowHeight, 
    Function? fnValid, Function? fnOnChange}){
        
    if (StrUt.notEmpty(initValue)){
      ctrl.text = initValue!;
    }
    return TextFormField(
      controller: ctrl,
      //initialValue: initValue,
      keyboardType: (isDecimal == null) ? TextInputType.text : 
        TextInputType.numberWithOptions(decimal: isDecimal),
        //TextInputType.number,
      inputFormatters: (isDecimal == null) ? null :
        isDecimal ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,-]'))] : 
        [FilteringTextInputFormatter.allow(RegExp('[0-9,-]'))],
        //[FilteringTextInputFormatter.digitsOnly],

      readOnly: !status,
      style: textStyle(status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      decoration: inputDecore(label, lowHeight),
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
        if (isDecimal != null && !canZero && !isEmpty){
          if ((isDecimal && double.parse(value!) == 0) || (!isDecimal && int.parse(value!) == 0 )){
            return FunUt.notZero;
          }
        }

        return (required && isEmpty) ? FunUt.notEmpty :
          (fnValid == null) ? null : 
          fnValid(value);          
      },
    );
  }

  /// select option(dropdown)
  /// DropdownButtonFormField 才有 validate, DropdownButton 沒有
  static Widget iselect(String label, dynamic value, List<IdStrDto> rows, Function? fnOnChange,
    {bool status = true, bool required = false, bool? lowHeight, Function? fnValid}){

    var value2 = rows.isEmpty ? '' :
      ListUt.missOrFirst(rows, value);

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value2,
      style: textStyle(status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      decoration: inputDecore(label, lowHeight),
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
      },
    );
  }

  static TableRow iselect2(String label, dynamic value, List<IdStrDto> rows, Function? fnOnChange,
    {bool status = true, bool required = false, bool? lowHeight, Function? fnValid}){

    return tableRow2(label, iselect('', value, rows, fnOnChange, status:status, 
      required:required, lowHeight:lowHeight, fnValid:fnValid), 
      required: required, lowHeight: lowHeight);
  }

  /// date input
  /// fnOnChange : must be (value)=>
  static Widget idate(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, 
    bool lowHeight = false, bool oneYearRange = true}){

    var days = oneYearRange ? 356 : 36500;
    var today = DateTime.now();
    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      decoration: inputDecore(label, lowHeight),
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
        : null
    );
  }

  static TableRow idate2(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, 
    bool lowHeight = false, bool oneYearRange = true}){

    return tableRow2(label,idate(context, '', ctrl, fnOnChange, status:status, 
      required:required, lowHeight:lowHeight, oneYearRange:oneYearRange), 
      required: required, lowHeight: lowHeight);
  }

  /// hour minutes
  static Widget itime(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, 
    {bool status = true, bool required = false, bool lowHeight = false}){

    var value = StrUt.isEmpty(ctrl.text) 
      ? TimeOfDay.now() : DateUt.strToTime(ctrl.text);
    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status),
      //decoration: (label == '') ? null : inputDecore(label, lowHeight),
      decoration: inputDecore(label, lowHeight),
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
        : null
    );
  }

  static TableRow itime2(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, 
    {bool status = true, bool required = false, bool lowHeight = false}){

    return tableRow2(label, itime(context, '', ctrl, fnCallback, status: status, 
        required:required, lowHeight:lowHeight), 
      required: required, lowHeight: lowHeight);
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
        getText(label, status, labelColor),
    ]);
  }

  static TableRow icheck2(String label, bool checked, Function fnOnChange, 
    {bool status = true}) {

    return tableRow2(label, icheck('', checked, fnOnChange, status:status));
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
      widgets.add(WG.getText(labelValues[i], status));
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

} //class
