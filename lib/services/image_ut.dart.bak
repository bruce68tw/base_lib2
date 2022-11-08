import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

  static Future<Image> reloadAssetAsync(String path) async {
    var byteData = await rootBundle.load(path); //load sound from assets
    return Image.memory(byteData.buffer.asUint8List());
  }  

  //repaintBoundary to image file
  static Future repaintToImageAsync(GlobalKey key, String toPath) async{
    //固定寫法
    var boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary?.toImage();
    var byteData = await image?.toByteData(format: ImageByteFormat.png);  //png only
    var bytes = byteData?.buffer.asUint8List();

    if (bytes != null) {
      var imageFile = await File(toPath).create();
      await imageFile.writeAsBytes(bytes);
    }
  }

} //class
