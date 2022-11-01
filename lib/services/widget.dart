import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/all.dart';
import 'all.dart';

//static class
class WG {

  /*
  static Text text(double size, String label, [Color? color, double? height]) {
    return Text(label, style: TextStyle(
      fontSize: size,
      //color: (color == null) ? Colors.black : color,
      color: color,
      height: height,
    ));
  }
  */

  static Text getText(String text, [bool status = true]) {
    return Text(text, style:textStyle(status));
  }

  static Text getLabel(String label) {
    return Text(label, style:FunUt.labelStyle);
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
  static TextStyle textStyle([bool status = true]) {    
    return TextStyle(
      color: status ? FunUt.textColorOk : FunUt.textColorSkip,
      fontSize: FunUt.fontSize,
    );
  }

  //return label
  static InputDecoration inputDecore(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: FunUt.decoreStyle,
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
    return Center(child: Text(
      msg, 
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      )));
  }

  ///link button
  ///VoidCallback is need, onPressed on ()=> before function !!
  static Widget textBtn(String text, [VoidCallback? fnOnClick]) {
    //var status = (fnOnClick != null);
    //var color = status
    //  ? Colors.blue : Colors.grey;
    return TextButton(
      child: Text(text),
      onPressed: (fnOnClick == null) ? null : fnOnClick,
    ); 
  }

  ///create TextButton
  ///VoidCallback is need, onPressed on ()=> before function !!
  static Widget elevBtn(String text, [VoidCallback? fnOnClick]) {
    //var status = (fnOnClick != null);
    //var color = status
    //  ? Colors.blue : Colors.grey;
    return ElevatedButton(
      child: Text(text),
      onPressed: (fnOnClick == null) ? null : fnOnClick,
    ); 
  }

  /// tablerow with label string & widget
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

  /// tablerow with 2 widgets
  static TableRow tableRow2(Widget widget1, Widget widget2){
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: widget1
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: widget2
      )
    ]);
  }

  /// required label
  static Widget reqLabel(String label, [bool required = true]){
    return required
      ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getLabel2('*', Colors.red),
            getLabel(label),
          ]
        )
      : getLabel(label);
  }

  static TableRow itext2(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, bool isPwd = false, 
    Function? fnValid, Function? fnOnChange}){
    return tableRow2(reqLabel(label, required), itext('', ctrl, status: status, 
      required: required, maxLines: maxLines, isPwd: isPwd,
      fnValid: fnValid, fnOnChange: fnOnChange));
  }

  //=== input field below ===
  static Widget itext(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, bool isPwd = false, 
    Function? fnValid, Function? fnOnChange}){
    
    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status),
      decoration: (label == '') ? null : inputDecore(label),
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
        return (required && StrUt.isEmpty(value)) ? FunUt.notEmpty :
          (fnValid == null) ? null : 
          fnValid(value);          
      },
    );
  }

  static TableRow iselect2(String label, dynamic value, List<IdStrDto> rows, Function fnOnChange,
    {bool status = true, bool required = false, Function? fnValid}){
    return tableRow2(reqLabel(label, required), iselect('', value, rows, fnOnChange,
    status:status, required:required, fnValid:fnValid));
  }

  /// select option(dropdown)
  static Widget iselect(String label, dynamic value, List<IdStrDto> rows, Function fnOnChange,
    {bool status = true, bool required = false, Function? fnValid}){

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: rows.isEmpty ? '' :
        (value == null || value.toString() == '') ? rows.first.id :
        value.toString(),
      //hint: label,
      //readOnly: !status,
      style: textStyle(status),
      //decoration: inputDecore(label),
      decoration: (label == '') ? null : inputDecore(label),
      items: rows.map((IdStrDto row) {
        return DropdownMenuItem<String>(
          child: Text(row.str),
          value: row.id,
        );
      }).toList(),
      onChanged: status 
        ? (value2)=> fnOnChange(value2)
        : null,
      validator: (value2) {
        return (required && StrUt.isEmpty(value2)) ? FunUt.notEmpty :
          (fnValid == null) ? null : 
          fnValid(value2);          
      },
    );
  }

  static TableRow idate2(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, bool oneYearRange = true}){
    return tableRow2(reqLabel(label, required), idate(context, '', ctrl,  
    fnOnChange, status:status, required:required, oneYearRange:oneYearRange));
  }

  /// date input
  /// fnOnChange : must be (value)=>
  static Widget idate(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, bool oneYearRange = true}){

    var days = oneYearRange ? 356 : 36500;
    var today = DateTime.now();
    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status),
      //decoration: inputDecore(label),
      decoration: (label == '') ? null : inputDecore(label),
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

  static TableRow itime2(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, {bool status = true, bool required = false}){
    return tableRow2(reqLabel(label, required), itime(context, '', 
    ctrl, fnCallback, status: status, required:required));
  }

  /// hour minutes
  static Widget itime(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, {bool status = true, bool required = false}){

    var value = StrUt.isEmpty(ctrl.text) 
      ? TimeOfDay.now() : DateUt.strToTime(ctrl.text);
    return TextFormField(
      controller: ctrl,
      readOnly: !status,
      style: textStyle(status),
      //decoration: WG.inputDecore(label),
      decoration: (label == '') ? null : inputDecore(label),
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

  static TableRow icheck2(String label, bool checked, Function fnOnChange, 
    {bool status = true}) {
    return tableLabelWidget(label, icheck('', checked, fnOnChange, 
    status:status));
  }

  /// checkbox, 裡面使用sizeBox會很不好點擊 !1 
  /// fnOnChange : must (value){} !!
  static Widget icheck(String label, bool checked, Function fnOnChange, 
    {bool status = true}) {

    return Row(
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
        getText(label, status),
    ]);
  }

  static Widget iradio(List<dynamic> labelValues, dynamic value, Function fnOnChange, 
    {bool status = true, bool isCenter = false}) {

    List<Widget> widgets = [];
    for(var i=0; i<labelValues.length; i+=2){
      widgets.add(Radio<dynamic>(
        value: labelValues[i+1],
        groupValue: value,
        onChanged: (val)=> fnOnChange(val)
      ));
      widgets.add(WG.getText(labelValues[i], status));
    }

    return Row(
      mainAxisAlignment: isCenter
        ? MainAxisAlignment.center
        : MainAxisAlignment.start,
      children: widgets
    );
    
  }

} //class
