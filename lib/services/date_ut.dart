// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'str_ut.dart';

//static class
class DateUt {
  //server datetime string format
  static const dtCsFormat = 'yyyy/MM/dd HH:mm:ss';
  static const dtCsFormat2 = 'yyyy/MM/dd HH:mm';
  static const dateCsFormat = 'yyyy/MM/dd';

  /// return yyyy/MM/dd hh:mm:ss
  static String format(String dts) {
    var dt = DateFormat(dtCsFormat).parse(dts);
    return DateFormat(dtCsFormat).format(dt);
  }

  /// return yyyy/MM/dd hh:mm
  static String format2(String dts) {
    var dt = DateFormat(dtCsFormat).parse(dts);
    return DateFormat(dtCsFormat2).format(dt);
  }

  /// return now string
  static String now2() {
    return DateFormat(dtCsFormat2).format(DateTime.now());
  }

  /*
  /// return now string
  static DateTime csToDt(String dts) {
    return DateTime.parse(dts.replaceAll('/', '-'));
  }
  */
  
  static TimeOfDay strToTime(String time) {
    var cols = time.split(":");
    return TimeOfDay(hour: int.parse(cols[0]), minute: int.parse(cols[1]));
  }

  /// cs datetime string to datetime
  /// <param name="dt">yyyy/MM/dd hh:mm:ss</param>
  /// <returns></returns>
  static DateTime? csToDt(String dt) {
      if (StrUt.isEmpty(dt)) return null;

      try {
        return DateTime.parse(dt.replaceAll('/', '-'));
      } catch (error){
        return null;
      }  
  }
  
  static String timeToStr(TimeOfDay time){
    return time.hour.toString() + ' : ' + 
        time.minute.toString();
  }

  //parse datetime string to 2 input ctrl
  static void strToCtrls(String? date, TextEditingController dateCtrl, TextEditingController timeCtrl){
    if (StrUt.isEmpty(date)){
      dateCtrl.text = '';
      timeCtrl.text = '';
    } else {
      var pos = date!.indexOf(' ');
      //var cols = date!.split(' ');
      dateCtrl.text = date.substring(0, pos);
      timeCtrl.text = date.substring(pos + 1);
    }
  }

  //get date string
  static String toDateStr(DateTime dt){
    return DateFormat(dateCsFormat).format(dt);
  }

  //get time string
  static String toTimeStr(DateTime dt){
    return DateFormat.Hm().format(dt);
  }

  //get time string
  static void setCtrlText(TextEditingController ctrl, bool setNow){
    var isEmpty = StrUt.isEmpty(ctrl.text);
    if (setNow && isEmpty) {
      ctrl.text = DateUt.toDateStr(DateTime.now());
    } else if (!isEmpty){
      var dt = csToDt(ctrl.text);
      if (dt == null || dt.year < 1900){
        ctrl.text = '';
      }
    }
  }

} //class
