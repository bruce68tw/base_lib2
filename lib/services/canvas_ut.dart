import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

//static class
class CanvasUt {
  //static const _dtCsFormat = 'yyyy/MM/dd HH:mm:ss';
  //static const _dtCsFormat2 = 'yyyy/MM/dd HH:mm';

  static Future<ui.Image> loadImageA(var path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetWidth: 300,targetHeight: 300);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;

    /*
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    } else {
      stream =
          AssetImage(path, bundle: rootBundle).resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    }

    stream.addListener(listener);
    return completer.future;
    */
  }

} //class
