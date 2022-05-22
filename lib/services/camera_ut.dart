import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

//static class
class CameraUt {

  static Widget camera(BuildContext context, CameraController ctrl){
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: ctrl.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: ctrl.value.aspectRatio,
          child: CameraPreview(ctrl),
        ),
      ),
    );
  }

} //class
