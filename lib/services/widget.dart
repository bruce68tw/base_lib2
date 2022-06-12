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

  static Widget gap2([double width = 5]) {
    return SizedBox(width: width);
  }

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

  static TableRow tableRow(String label, Widget widget){
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

  static TableRow itext2(String label, TextEditingController ctrl,  
    {bool status = true, bool required = false, int maxLines = 1, bool isPwd = false, 
    Function? fnValid, Function? fnOnChange}){
    return tableRow(label, itext('', ctrl, status: status, 
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
    return tableRow(label, iselect('', value, rows, fnOnChange,
    status:status, required:required, fnValid:fnValid));
  }

  /// select option(dropdown)
  static Widget iselect(String label, dynamic value, List<IdStrDto> rows, Function fnOnChange,
    {bool status = true, bool required = false, Function? fnValid}){

    return DropdownButtonFormField<String>(
      value: (value == null || value.toString() == '') 
        ? rows.first.id : value.toString(),
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
      onChanged: (value2)=> fnOnChange(value2),
      validator: (value2) {
        return (required && StrUt.isEmpty(value2)) ? FunUt.notEmpty :
          (fnValid == null) ? null : 
          fnValid(value2);          
      },
    );
  }

  /*
  //fnOnChange無法使用name parameter !!
  static Widget zz_iselect(InputDecoration inputLabel, String value, List<IdStrDto> rows, 
    [bool required = false, Function? fnOnChange]){

    if (value == ''){
      value = rows.first.id;
    }

    return InputDecorator(
      //decoration: const InputDecoration(border: OutlineInputBorder()),
      decoration: inputLabel,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          onChanged: (String? newValue){
            if (fnOnChange != null) fnOnChange(newValue);
          },
          items: rows.map((IdStrDto row) {
            return DropdownMenuItem<String>(
              child: Text(row.str),
              value: row.id,
            );
          }).toList(),
        ),
      ),
    );
  }
  */

  static TableRow idate2(BuildContext context, String label, TextEditingController ctrl,  
    Function fnOnChange, {bool status = true, bool required = false, bool oneYearRange = true}){
    return tableRow(label, idate(context, '', ctrl,  
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
      onTap: () async {
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
      },
    );
  }

  static TableRow itime2(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, {bool required = false}){
    return tableRow(label, itime(context, '', 
    ctrl, fnCallback, required:required));
  }

  /*
  */
  static Widget itime(BuildContext context, String label, 
    TextEditingController ctrl, Function fnCallback, {bool required = false}){

    var value = StrUt.isEmpty(ctrl.text) 
      ? TimeOfDay.now() : DateUt.strToTime(ctrl.text);
    return TextFormField(
      controller: ctrl,
      style: WG.textStyle(),
      //decoration: WG.inputDecore(label),
      decoration: (label == '') ? null : inputDecore(label),
      onTap: () async {
        //TimeOfDay.now()
        //_nowDate = value;
        final time = await showTimePicker(
          context: context, 
          initialTime: value
        );

        if (time != null) {
          ctrl.text = DateUt.timeToStr(time);
        }

        //callback
        fnCallback(time);
      },
    );
  }

  static TableRow icheck2(String label, bool checked, Function fnOnChange, 
    {bool status = true}) {
    return tableRow(label, icheck('', checked, fnOnChange, 
    status:status));
  }

  /// checkbox 
  /// fnOnChange : must (value){} !!
  static Widget icheck(String label, bool checked, Function fnOnChange, 
    {bool status = true}) {

    /*
    //design color
    Color getColor(Set<MaterialState> states) {
      
      //const Set<MaterialState> interactiveStates = <MaterialState>{
      //  MaterialState.pressed,
      //  MaterialState.hovered,
      //  MaterialState.focused,
      //};

      //if (states.any(interactiveStates.contains)) {
      //  return Colors.blue;
      //}
      //return Colors.red;
      
      return Colors.grey;
    }
    */

    return Row(
      children: [     
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
          child: SizedBox(height: 24.0, width: 24.0,
            child: Checkbox(
              //checkColor: Colors.white,
              //fillColor: MaterialStateProperty.resolveWith(getColor),
              value: checked,
              onChanged: (bool? value) {
                fnOnChange(value);
        }))),
        getText(label, status),
    ]);
  }

} //class
