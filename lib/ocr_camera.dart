// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';
import 'services/tool_ut.dart';
import 'services/widget.dart';

//ocr camera image to text
class OcrCamera extends StatefulWidget {
  const OcrCamera({Key? key, required this.title, this.lineSep = '\n'}) : super(key: key);
  final String title;
  final String lineSep;

  @override
  State<StatefulWidget> createState()=> OcrCameraState();
}

class OcrCameraState extends State<OcrCamera> {
  bool _isOk = false;
  bool _readStream = false;   //控制ImageStream,否則會OutOfMemory !!
  CameraController? cameraCtrl;
  //late String _wordSep;   //文字分隔符號
  bool _lightStatus = false;

  // Initializing the TextDetector
  //final _textRecoger = GoogleMlKit.vision.textRecognizer();
  final _textRecoger = TextRecognizer(script: TextRecognitionScript.latin);

  //辨視結果判斷2次
  String _resultText = '';
  String _resultText2 = ''; 
  
  @override
  void initState() {
    super.initState();

    //_wordSep = widget.multiLine ? '\n' : ' ';
    _initCameraA();  // for camera initialization
  }
  
  @override
  void dispose() {
    if (cameraCtrl != null){
      //cameraCtrl!.stopImageStream();
      //_readStream = false;
      //cameraCtrl!.pausePreview();
      cameraCtrl!.dispose();
    } 
    super.dispose();
  }

  Future<void> _initCameraA() async {
    // Get list of cameras of the device
    var cameras = await availableCameras();
    if(cameras.isEmpty){
        ToolUt.msg(context, 'No Camera !!');
        return;
    }
    
    // Initialize the CameraController
    cameraCtrl = CameraController(cameras[0], ResolutionPreset.low);
    cameraCtrl!.initialize().then((_) async {
      if (mounted) {        
        _readStream = true;
        cameraCtrl!.resumePreview();

        // Start streaming images from platform camera
        await cameraCtrl!.startImageStream(
          (CameraImage image) => onStreamA(image));  // image processing and text recognition.

        setState(()=> _isOk = true);
      }        
    });
  }    

  /*
  Future<void> setCameraA(bool status) async {
    if (status){
      cameraCtrl!.resumePreview();

      _readStream = true;
      // Start streaming images from platform camera
      await cameraCtrl!.startImageStream(
        (CameraImage image) => onStreamA(image));  // image processing and text recognition.

    } else {
      cameraCtrl!.pausePreview();
    }
  }
  */

  //辨視2次相同即顯示文字內容 & 暫停stream
  Future<void> onStreamA(CameraImage image) async {
    if (!_readStream) return;

    _readStream = false;

    // getting InputImage from CameraImage
    var inputImage = _getInputImage(image);
    var recognizedText = await _textRecoger.processImage(inputImage);

    // Using the recognised text.
    var text = '';
    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        text += line.text + widget.lineSep;
      }
    }    

    text = text.trim();
    if (text == ''){
      _readStream = true;
      return;
    } 

    //辨視結果判斷2次
    if (_resultText == ''){
      _resultText = text;
    } else if(_resultText == text) {
      _resultText2 = text;
    } else {
      _resultText = '';
      _resultText2 = '';
    }

    _readStream = (_resultText2 == '');

    //先判斷mounted, 否則dispose()會error
    if (mounted) setState((){});
  }

  /// 設定燈光
  Future<void> onLightA() async {
    _lightStatus = !_lightStatus;
    cameraCtrl!.setFlashMode(_lightStatus ? FlashMode.torch : FlashMode.off);
  }

  //CameraImage(flutter camera 圖檔格式) to InputImage
  InputImage _getInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();
    final size = Size(image.width.toDouble(), image.height.toDouble());
 
    final rotate = InputImageRotationValue.fromRawValue(
      cameraCtrl!.description.sensorOrientation) 
      ?? InputImageRotation.rotation0deg;

    final format = InputImageFormatValue.fromRawValue(image.format.raw) 
      ?? InputImageFormat.nv21;
 
    final planeData = image.planes.map((Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );})
      .toList();
 
    final imageData = InputImageData(
      size: size,
      imageRotation: rotate,
      inputImageFormat: format,
      planeData: planeData,
    );
 
    return InputImage.fromBytes(bytes: bytes, inputImageData: imageData);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOk) return Container();

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    //var width = MediaQuery.of(context).size.width;
    var hasText = (_resultText2 != '');
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width,
            height: size.width * 0.75,
            //ClipRect限定高度
            child: ClipRect(
              child: Center(
                //Transform縮放
                child: Transform.scale(
                  scale: cameraCtrl!.value.aspectRatio * 0.8 / deviceRatio,
                  //AspectRatio設定長寬比例
                  child: AspectRatio(
                    aspectRatio: cameraCtrl!.value.aspectRatio  * 0.75 * 0.75,
                    child: CameraPreview(cameraCtrl!),
          ))))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WG.getLabel('辨視結果：'),
                  WG.getText(_resultText2),
          ]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WG.elevBtn('確定', hasText ? (){
                ToolUt.closeFormMsg(context, _resultText);
              } : null),
              WG.hGap(),
              WG.elevBtn('重新辨視', hasText ? (){ 
                _readStream = true;
                setState((){});
              } : null),
              WG.hGap(),
              WG.elevBtn('手電筒', onLightA),
          ])
    ]));
  }

}