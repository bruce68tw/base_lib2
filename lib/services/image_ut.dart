import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as image2;

import 'file_ut.dart';

//image
class ImageUt {

  /// reload image
  /// flutter image has cache issue !!
  static Image reload(String path){
    var file = File(path);
    var bytes = file.readAsBytesSync();
    return Image.memory(bytes, fit: BoxFit.fill);
  }  

  static List<int>? encode(image2.Image image, String ext) {
    switch(ext){
      case 'jpg':
        return image2.encodeJpg(image);
      case 'png':
        return image2.encodePng(image);
      case 'gif':
        return image2.encodeGif(image);
      case 'bmp':
        return image2.encodeBmp(image);
      default:
        return null;
    }
  }

  static Future<image2.Image?> decodeAsync(String filePath, [String? ext]) async {
    ext ??= FileUt.getExt(filePath);
    switch(ext){
      case 'jpg':
        return image2.decodeJpg(await File(filePath).readAsBytes());
      case 'png':
        return image2.decodePng(await File(filePath).readAsBytes());
      case 'gif':
        return image2.decodeGif(await File(filePath).readAsBytes());
      case 'bmp':
        return image2.decodeBmp(await File(filePath).readAsBytes());
      default:
        return null;
    }
  }

} //class
