//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'services/all.dart';

//3.getx controller
class AutoUpdateCtrl extends GetxController {
  //List<WoItemDto> _items = [];
  String rate = '';

  /*
  //constructor
  W2List0Ctrl(List<WoItemDto> items) {
    _items = items;
  }
  */

  //todo
  void setRate(String newRate) {
    rate = newRate;
  }

  /*
  void reload(List<WoItemDto> items){
    _items = items;
    update();
  }

  WoItemDto getItem(int index) {
    return _items[index];
  }

  List<WoItemDto> getItems() {
    return _items;
  }

  int getLen() {
    return _items.length;
  }

  int getCheckedLen() {
    return _items.where((a) => a.checked).length;
  }

  //已存在 update() !!
  toggle(WoItemDto item) {
    //int index = _items.indexOf(item);
    //_items[index].checked = !_items[index].checked;
    item.checked = !item.checked;   //workable
    update();
  }

  delete(String id) {
    _items.removeWhere((element) => element.id == id);
    update();
  }

  deletes(List<String> idList) {
    _items.removeWhere((element) => idList.contains(element.id));
    update();
  }
  */
}

//自動改版 for android/ios
class AutoUpdate extends StatefulWidget {
  const AutoUpdate({ Key? key, required this.title, required this.msg, 
    required this.apkUrl }) : super(key: key);
  final String title;
  final String msg;
  final String apkUrl;

  @override
  AutoUpdateState createState() => AutoUpdateState();
}

class AutoUpdateState extends State<AutoUpdate> {
  bool _isOk = false;   //status
  late AutoUpdateCtrl myCtrl;

  @override
  void initState() {
    //set global
    
    //call before rebuild()
    super.initState();

    //讀取資料, call async rebuild
    Future.delayed(Duration.zero, ()=> _showA());
  }

  Future<void> _showA() async {
    //openDlg();
    setState(()=> _isOk = true);
  }

  Future<bool> _checkAuthA() async{
    //case of ios
    if(!DeviceUt.isAndroid(context)) return false;

    //todo temp
    return true;
    //是否授權儲存
    if (await Permission.storage.status != PermissionStatus.granted) return false;  

    return (await Permission.storage.request() == PermissionStatus.granted);
  }

  //download and install
  Future<void> _downloadA() async{
    if (!await _checkAuthA()) return;

    var saveDir = await getExternalStorageDirectory();
    var savePath = "${saveDir!.path}/new.apk";
    //var apkUrl = "https://jdmall.itying.com/jdshop.apk";

    /*
    //Dio dio = Dio();
    await Dio().download(widget.apkUrl, savePath, onReceiveProgress: (received, total) async {
      if(total != -1){
        print("${(received/total*100).toStringAsFixed(0)}%");
      }
    });
    print(savePath);
    await OpenFile.open(savePath, type: "application/vnd.android.package-archive");
    */

    try {
      var dio = Dio();
      var response = await dio.download(widget.apkUrl, savePath, onReceiveProgress: (received, total) async {
        if (total != -1) {
          //print((received / total * 100).toStringAsFixed(0) + "%");
          myCtrl.setRate((received / total * 100).toStringAsFixed(0));
        }
        /*  
        if(total != -1){
          print("${(received/total*100).toStringAsFixed(0)}%");
        }
        */
      });
      //print(savePath);
      if (response.statusCode == 200) {
        //print('下载请求成功');
        //安装, 開發模式下無法執行 !!
        await OpenFile.open(savePath, type: "application/vnd.android.package-archive");
      } else {
        //"下载失败重试";
      }

    } catch (e) {
      //todo
    }

      /*
    try {
      Response response = await Dio().get(
        widget.apkUrl,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      //print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      
      await OpenFile.open(savePath, type: "application/vnd.android.package-archive");
    } catch (e) {
      //print(e);
      var aa = 'aa';
    }    
    */
  }

  /*
  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    //check status
    if (!_isOk) return Container();

    return Scaffold(
      appBar: WG.appBar(widget.title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,        
        children: [
          Container(
            margin: const EdgeInsets.only(left:40, right:40, bottom:10),
            padding: const EdgeInsets.all(10.0),
            decoration:  BoxDecoration(
              border: Border.all(
                width: 1,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,        
              children: [
                Text(
                  widget.msg,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WG.elevBtn('  離開  ', (){}),
                    WG.hGap(),
                    WG.elevBtn(' 執行改版 ', ()=> _downloadA())
                ])
              ]
            )
          ),
          GetBuilder(       
            init: AutoUpdateCtrl(),  //need
            //global: false, 
            builder: (AutoUpdateCtrl ctrl) {
              //set instance variables
              myCtrl = ctrl;
              return WG.getText('執行進度: ${ctrl.rate} %');
          })

          //WG.vExpand(),
    ]));
  }
}