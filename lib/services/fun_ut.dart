// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'str_ut.dart';

//static class, cannot use _Fun
class FunUt {
  /// appBar pager button gap
  //static const pageBtnGap = EdgeInsets.all(15); 
  ///constant
  static const systemError = "System Error, Please Contact Administrator.";
  
  static const select = '--請選擇--';
  static const notEmpty = '不可空白。';
  static const notZero = '不可為0';
  static const onlyNum = '只能輸入數字。';

  //system config
  static bool logHttpUrl = false;


  //=== style start ===
  static double fontSize = 18.0;
  static double errorFontSize = 16.0;
  static Color textColorEdit = Colors.black;
  static Color textColorRead = Colors.grey;
  static double fieldHeight = 45;
  static double fieldHeightLow = 35;
  //=== style end ===


  //label, also for inputDecoration
  static TextStyle labelStyle = TextStyle(
      fontSize: fontSize,
      color: Colors.grey,
  );

  //label, also for inputDecoration
  static TextStyle decoreStyle = const TextStyle(
      fontSize: 15,
      color: Colors.grey,
      height: 0.8,
  );

  ///indicate error
  static const preError = 'E:';

  //#region input parameters
  /// api is https or not
  static bool isHttps = false; 

  /// api server
  static String apiServer = ''; 
  //#endregion
  
  /// login status
  static bool isLogin = false; 

  /// app dir
  static String dirApp = '';
  static String dirTemp = '';

  /// initial
  static Future init(bool isHttps, String apiServer) async {
    if (!StrUt.isEmpty(FunUt.apiServer)) return;

    FunUt.isHttps = isHttps;
    FunUt.apiServer = apiServer;

    var dir = await getApplicationDocumentsDirectory();
    dirApp = dir.path + '/';
    dirTemp = dirApp + '_temp/';
  }

} //class
