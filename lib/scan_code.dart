import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'services/tool_ut.dart';
import 'services/widget.dart';

//scan qrCode & barCode
class ScanCode extends StatefulWidget {
  const ScanCode({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState()=> ScanCodeState();
}

class ScanCodeState extends State<ScanCode> {
  final GlobalKey _formKey = GlobalKey(debugLabel: 'ScanCode');
  QRViewController? _scanCtrl;
  bool _hasFlash = false;   //閃光燈狀態

  @override
  void dispose() {
    _scanCtrl?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      _scanCtrl!.pauseCamera();
    } else if (Platform.isIOS) {
      _scanCtrl!.resumeCamera();
    }
  }

  /*
  void onScannerCreate(QRViewController ctrl) {
    ctrl.resumeCamera();   //active scanner
    _scanCtrl = ctrl;
    ctrl.scannedDataStream.listen((scanData) {
      if (scanData.code != null){
        _scanCtrl!.dispose();
        ToolUt.closeForm(context, scanData.code);
      }
    });
  }
  */

  /*
  void readQrAsync() async {
    if (_barCode != null) {
      _qrViewCtrl!.pauseCamera();
      //print(result!.code);
      _qrViewCtrl!.dispose();
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    //if (!_isOk) return Container();

    //QRView 必須與其他widget分隔, 否則會error !!
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                  key: _formKey,
                  onQRViewCreated: (ctrl){
                    _scanCtrl = ctrl;
                    ctrl.resumeCamera();   //active scanner
                    ctrl.scannedDataStream.listen((scanData) {
                      if (scanData.code != null){
                        _scanCtrl!.dispose();
                        ToolUt.closeFormMsg(context, scanData.code!);
                      }
                    });
                  },
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.orange,
                    borderRadius: 10,
                    borderLength: 20,
                    borderWidth: 10,
                    cutOutSize: 250,
                )),
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, left:5),
                    child: IconButton(
                      //iconSize: 30,
                      icon: Icon(_hasFlash ? Icons.flash_on : Icons.flash_off,
                        size: 30, color: Colors.yellow),
                      //highlightColor: Colors.pink,
                      onPressed: (){
                        _scanCtrl!.toggleFlash();
                        setState(()=> _hasFlash = !_hasFlash);
                      }
                  )))
              ]
            )
          
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WG.getText('請將條碼放置於框內掃描'),
                /*
                WG.elevBtn('閃光燈 ${_hasFlash ? 'Off' : 'On'}', (){
                  _scanCtrl!.toggleFlash();
                  setState(()=> _hasFlash = !_hasFlash);
                })
                */
              ]
    ))]));
  }

}