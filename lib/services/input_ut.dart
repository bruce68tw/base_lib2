import 'package:flutter/material.dart';
import 'package:base_lib/all.dart';
import 'package:intl/intl.dart';

/// static class(widget)
class InputUt {

  static Widget itext(TextEditingController ctrl, 
    TextStyle inputStyle, InputDecoration inputLabel, 
    [bool required = false, Function? fnValid, Function? fnOnChange]){
    
    //var label2 = required 
    //  ? label + '*' : label;
    return TextFormField(
      controller: ctrl,
      //initialValue: 'Taipei',
      style: inputStyle,
      decoration: inputLabel,
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

  static Widget iselect(Text label, String value, List<IdStrDto> rows, 
    [bool required = false, Function? fnValid, Function? fnOnChange]){
    return DropdownButtonFormField<String>(
      value: value,
      hint: label,
      onChanged: (newValue) {
        if (fnOnChange != null) fnOnChange(newValue);
      },
      validator: (value) {
        return (required && StrUt.isEmpty(value)) ? FunUt.notEmpty :
          (fnValid == null) ? null : 
          fnValid(value);          
      },
      items: rows.map((IdStrDto row) {
        return DropdownMenuItem<String>(
          child: Text(row.str),
          value: row.id,
        );
      }).toList(),
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

  static Widget idate(BuildContext context, TextEditingController ctrl, 
    String label, Function fnCallback,
    [bool required = false, String? label2]){

    var today = DateTime.now();
    return TextFormField(
      controller: ctrl,
      onTap: () async {
        //_nowDate = value;
        // Below line stops keyboard from appearing
        FocusScope.of(context).requestFocus(FocusNode());
        // Show Date Picker Here
        //await _openDate(context);
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: StrUt.isEmpty(ctrl.text) 
            ? DateTime.now() : DateUt.strToDt(ctrl.text),
          firstDate: today.add(const Duration(days: -365)), 
          lastDate: today.add(const Duration(days: 365)),
        );

        if (date != null) {
          ctrl.text = DateFormat(DateUt.dateCsFormat).format(date);
        }

        fnCallback();
        //ctrl.text = DateFormat('yyyy/MM/dd').format(_nowDate);
        //setState(() {});
      },
      style: WG.inputStyle(),
      decoration: WG.inputLabel(label),
    );
  }

  static Widget itime(BuildContext context, TextEditingController ctrl, 
    String label, Function fnCallback,
    [bool required = false, String? label2]){

    var value = StrUt.isEmpty(ctrl.text) 
      ? TimeOfDay.now() : DateUt.strToTime(ctrl.text);
    return TextFormField(
      controller: ctrl,
      onTap: () async {
        //TimeOfDay.now()
        //_nowDate = value;
        final time = await showTimePicker(
          context: context, 
          initialTime: value
        );

        if (time != null) {
          ctrl.text = Xp.timeStr(time);
        }

        //callback
        fnCallback();
      },
      style: WG.inputStyle(),
      decoration: WG.inputLabel(label),
    );
  }

  static Widget icheck(String label, bool status, Function fnOnChange) {

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

    return Row(
      children: [        
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: status,
          onChanged: (bool? value) {
            fnOnChange(value);
            /*
            (fnOnChange == null)
              ? (){} 
              : ()=> fnOnChange(value);
              */
          },
        ),
        WidgetUt.text(18, label),
    ]);
  }
  */

} //class