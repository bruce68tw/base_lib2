// ignore_for_file: library_prefixes, use_build_context_synchronously

//import 'package:image/image.dart' as DiImage;  //dart image
import 'package:base_lib/all.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

//signature to image file
class Signer extends StatefulWidget {
  const Signer({Key? key, required this.labelSave, required this.labelClear, 
    required this.savePath, required this.fnOnSignA}) : super(key: key);
  final String labelSave;
  final String labelClear;
  final String savePath;
  final Function fnOnSignA;

  @override
  State<StatefulWidget> createState()=> SignerState();
}

class SignerState extends State<Signer> {
  late double _width;
  late double _height;

  final _repaintKey = GlobalKey();  //for save signature

  final SignatureController _signCtrl = SignatureController(
    penStrokeWidth: 4,          //畫筆寬度
    penColor: Colors.black,   //畫筆顏色
  );

  late Signature _signCanvas;

  /*
  @override
  void initState() {
    super.initState();
    //_signCtrl.addListener(()=> print('Value changed'));
  }
  */

  @override
  void dispose() {
    _signCtrl.dispose();
    super.dispose();
  }

  /*
  //使用
  //參考signature.dart toPngBytes()
  Future<Uint8List?> toPngBytes() async {
    //get ui.image
    final ui.Image? uiImage = await _signCtrl
      .toImage(width: _height.round(), height: _width.round());
      //.toImage(height: _signCanvas.height!.round(), width: _signCanvas.width!.round());

    if (uiImage == null) return null;

    //ui.image -> byteData
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

    //byteData -> Int8List
    var int8List = byteData!.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

    //Int8List => listInt
    var listInt = int8List.cast<int>();
    //var listInt = int8List.map((a) => a.toInt()).toList();

    //listInt -> dart image(很慢!!)
    var image2 = DiImage.decodePng(listInt);
    //Image image2 = Image.memory(
    //  Uint8List.view(bytes!.buffer)
    //);

    //dart image rotate 90 degree(to landscape)(很慢!!)
    image2 = DiImage.copyRotate(image2!, 90);

    //img.copyPhotoAsync
    /*
    final ByteData? bytes = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    */
    return image2.getBytes();
    //return bytes?.buffer.asUint8List();
  }
  */

  @override
  Widget build(BuildContext context) {
    _width = DeviceUt.getWidth(context);
    _height = DeviceUt.getHeight(context);

    //不能寫在 initState()
    _signCanvas = Signature(
      controller: _signCtrl,
      height: _width - 50,
      width: _height,
      backgroundColor: Colors.white,
    );

    return Scaffold(
      body: RotatedBox(
        quarterTurns: 1,
        child: SizedBox(
          width: _height,
          height: _width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //簽名內容使用RepaintBoundary儲存
              RepaintBoundary(
                key: _repaintKey,
                child: Expanded(
                  child: _signCanvas
              )),

              //2個功能按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisAlignment: MainAxisAlignment.center,
                //mainAxisSize: MainAxisSize.max,
                children: [
                  WG.elevBtn(widget.labelSave, () async {
                    /*
                    final Uint8List? bytes = await toPngBytes();
                    if (bytes == null) return;
                    */
                    await ImageUt.repaintToImageA(_repaintKey, widget.savePath);

                    ToolUt.closeForm(context);
                    widget.fnOnSignA();
                  }),
                  WG.elevBtn(widget.labelClear, (){
                    setState(()=> _signCtrl.clear());
    })])]))));
  }

}