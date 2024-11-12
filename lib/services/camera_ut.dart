import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

//static class
class CameraUt {

  /*
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
  static Future<bool> initA(CameraController? ctrl) async {
    var cameras = await availableCameras();
    if(cameras.isEmpty) return false;

    ctrl = CameraController(cameras[0], ResolutionPreset.max);            
    ctrl!.initialize().then((_) async {
      if (_.mounted) {
        setCamera(false);   //先不啟動camera
        await setFocusModeA(_focusMode);
      }        
    });
  }

  static void dispose(CameraController? ctrl){
    if (ctrl != null) ctrl.dispose();
  }
  */

} //class
