import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'str_ut.dart';

//static class
class DateUt {
  //server datetime string format
  static const dtCsFormat = 'yyyy/MM/dd HH:mm:ss';
  static const dtCsFormat2 = 'yyyy/MM/dd HH:mm';
  static const dateCsFormat = 'yyyy/MM/dd';

  /// return yyyy/MM/dd hh:mm
  static String format2(String dts) {
    //var format = 'yyyy-MM-dd HH:mm';
    var dt = DateFormat(dtCsFormat).parse(dts);
    //var dt = dateFormat.parse(dts);
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

      return DateTime.parse(dt.replaceAll('/', '-'));
      //DateTime.TryParseExact(dt, _Fun.CsDtFmt, CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt2);
      //return dt2;
  }
  
} //class
