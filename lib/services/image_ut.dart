import 'dart:io';
import 'package:flutter/widgets.dart';

//image
class ImageUt {

  /// reload image
  /// flutter image has cache issue !!
  static Image reload(String path){
    var file = File(path);
    var bytes = file.readAsBytesSync();
    return Image.memory(bytes);
  }  

} //class
