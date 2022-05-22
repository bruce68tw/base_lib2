import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';

//static class
class WidgetUt {

  static Text text(double size, String label, [Color? color, double? height]) {
    return Text(label, style: TextStyle(
      fontSize: size,
      //color: (color == null) ? Colors.black : color,
      color: color,
      height: height,
    ));
  }

  ///gap for padding or margin
  static EdgeInsets gap(double pixel) {
    return EdgeInsets.all(pixel);
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
  static Widget linkBtn(String text, double fontSize, [VoidCallback? fnOnClick]) {
    var status = (fnOnClick != null);
    var color = status
      ? Colors.blue : Colors.grey;
    return TextButton(
      child: WidgetUt.text(fontSize, text, color),
      onPressed: status ? fnOnClick : null,
    ); 
  }

  ///create TextButton
  ///VoidCallback is need, onPressed on ()=> before function !!
  static Widget textBtn(String text, double fontSize, [VoidCallback? fnOnClick]) {
    var status = (fnOnClick != null);
    var color = status
      ? Colors.blue : Colors.grey;
    return ElevatedButton(
      child: WidgetUt.text(fontSize, text, color),
      onPressed: status ? fnOnClick : null,
    ); 
  }

} //class
