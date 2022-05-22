//1.dart sdk
import 'dart:io';
//import 'dart:developer';
import 'dart:convert';
import 'dart:typed_data';
//2.flutter sdk
//import 'package:camera/camera.dart';
//import 'package:dio/dio.dart' as dio;
//import 'package:dio/dio.dart' as d2;
import 'package:flutter/widgets.dart';
//3.3rd package
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
//4.base_lib
import 'package:base_lib/all.dart';
import 'package:http_parser/http_parser.dart';

//static class
class HttpUt {
  /// jwt token
  static String _token = '';

  static void setToken(String token) {
    _token = token;
  }

  //get api uri
  //json must be <String, String> or cause error !!
  static Uri _apiUri(String action, [Map<String, dynamic>? json]) {
    return FunUt.isHttps
        ? Uri.https(FunUt.apiServer, action, json)
        : Uri.http(FunUt.apiServer, action, json);
  }

  /*
  static String _apiUrl(String action) {
    var uri = _apiUrl(action);
    return uri.toString();
  }
  */

  static Future getStrAsync(BuildContext? context, String action,
      bool jsonArg, [Map<String, dynamic>? json, Function? fnOk, File? file]) async {
    await _rpcAsync(context, action, jsonArg, false, json, fnOk, file);
  }

  static Future getJsonAsync(
      BuildContext? context, String action, bool jsonArg, 
      [Map<String, dynamic>? json, Function? fnOk, File? file]) async {
    await _rpcAsync(context, action, jsonArg, true, json, fnOk, file);
  }

  static Future<Image?> getImageAsync(BuildContext? context, 
      String action, [Map<String, String>? json]) async {
    var resp = await _getRespAsync(context, action, false, json);
    return (resp == null) ? null : Image.memory(resp.bodyBytes);
  }

  static Future uploadZipAsync(BuildContext? context, String action,
      File file, [Map<String, dynamic>? json, bool jsonOut = false, Function? fnOk]) async {
    await _rpcAsync(context, action, false, jsonOut, json, fnOk, file);
  }

  ///download and unzip
  static Future saveUnzipAsync(BuildContext context, String action, 
      Map<String, String> json, String dirSave) async {

    //create folder if need
    var dir = Directory(dirSave);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    //if no file, download it
    //var action = isBatch ? 'GetBatchImage' : 'GetStepImage';
    var bytes = await _getFileBytesAsync(context, action, json);
    if (bytes != null) {
      var files = ZipDecoder().decodeBytes(bytes);
      var dirBase = dir.path + '/';
      for (var file in files) {
        //..cascade operator
        File(dirBase + file.name)
          ..createSync()
          ..writeAsBytesSync(file.content as List<int>, flush:true);
      }        
    }
  }

  static Future<Uint8List?> _getFileBytesAsync(BuildContext? context, 
      String action, [Map<String, String>? json]) async {
    var resp = await _getRespAsync(context, action, false, json);
    return (resp == null) ? null : resp.bodyBytes;
  }

  ///get response
  ///called by: _rpcAsync, getFileBytesAsync
  ///file不為空白時, jsonArg必須為false, 因為後端無法以object接受參數
  static Future<http.Response?> _getRespAsync(BuildContext? context, String action, 
    [bool jsonArg = false, Map<String, dynamic>? json, File? file]) async {
        
    String body = '';
    String conType;
    Map<String, dynamic>? arg;
    //1.set content type
    if (jsonArg){
      body = (json == null) ? '' : jsonEncode(json);
      conType = 'application/json';
    } else {
      conType = 'plain/text';
      arg = json; //as query string
    }
    var headers = {
      'Content-Type': conType + '; charset=utf-8',
      //'Access-Control-Allow-Origin': '*',
      //'Cache-Control': 'no-cache',
    };

    //2.add token if existed
    if (!StrUt.isEmpty(_token)) headers['Authorization'] = 'Bearer ' + _token;

    //3.show waiting
    ToolUt.openWait(context);

    //4.http request
    http.Response? resp;
    try {
      if (file == null) {
        resp = await http
          .post(
            _apiUri(action, arg),
            headers: headers,
            body: body)
          .timeout(const Duration(seconds: 30));
      } else {

        /*
      var dio2 = d2.Dio(d2.BaseOptions(
        baseUrl: 'http://192.168.1.103:5001/api',
        //contentType: 'multipart/form-data',
        connectTimeout: 5000, //5s
        receiveTimeout: 5000,
      ));
      dio2.options.headers.addAll({'Content-Type': 'application/json'});
      //dio.options.headers['Authorization'] = '$token';
      //dio2.options.baseUrl = _apiUri(action).path;
      //dio.options.headers = <Header Json>;
      var formData = d2.FormData.fromMap({'Id':'id1', 'WorkNo':'work no1'});
      //formData.fields.addAll();
      //formData.add("user_id", userProfile.userId);
      //formData.add("name", userProfile.name);
      //formData.add("email", userProfile.email);
      //formData.files.add("user_picture", new UploadFileInfo(photoFile, 'image0.jpg'));
      var file2a = d2.MultipartFile.fromFileSync(file.path);
          //filename: 'temp.jpg',
          //contentType: MediaType('image', 'jpg'));

      formData.files.add(MapEntry('file', file2a));

      d2.Response resp2 = await dio2.post(
        '/Project/SendAudit',
        data: formData,
      );

      var aa = 'aa';
*/

      /*
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',        
      };
      */

        //arg = {'Id':'id1', 'WorkNo':'work no1'};
        var request = http.MultipartRequest('POST', _apiUri(action, arg));
        //var request = http.MultipartRequest('POST', _apiUri(action));
        request.headers.addAll(headers);

        /*
        request.files.add(
          http.MultipartFile.fromBytes(
            'row',
            utf8.encode(jsonEncode({'Id':'id1', 'WorkNo':'work no1'})),
            contentType: MediaType(
              'application',
              'json',
              {'charset': 'utf-8'},
            ),
          ),
        );
        */

        //add text fields
        //request.fields["text_field"] = text;
        //request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
        //request.headers['Content-Type'] = 'multipart/form-data';
        //request.headers['Content-Type'] = 'application/json';
        //add file
        //var file2 = await http.MultipartFile.fromPath('file', file.path);
        var file2 = await http.MultipartFile.fromPath('file', file.path,
          //filename: 'temp.jpg',
          //contentType: MediaType('image', 'jpg'));
          contentType: MediaType('zip', 'applicaiton/zip'));
          
        //var file2 = await http.MultipartFile.fromPath('file', file.path, 
        //  filename: 'temp.zip', contentType: MediaType('zip','application/zip'));
        request.files.add(file2);
        //request.fields.addAll({'Id':'id1', 'WorkNo':'work no1'});
        //if (json != null){
        //  request.fields.addAll(JsonUt.dynamicToString(json)!);
        //}
        var stream = await request.send();
        resp = await http.Response.fromStream(stream);        

      }
    /*
    } on TimeoutException {
      log('Error: 連線時間超過20秒。');
      return null;
    */
    } catch (e) {
      LogUt.error('Error: $e');
    } finally {	
      //close waiting
      ToolUt.closeWait(context);
    }

    return resp;
  }

  static Future _rpcAsync(BuildContext? context, String action, bool jsonArg, 
      bool jsonOut, [Map<String, dynamic>? json, Function? fnOk, File? file]) async {
        
    //get response & check error
    var resp = await _getRespAsync(context, action, jsonArg, json, file);
    if (resp == null) {
      ToolUt.msg(context, '無法存取遠端資料 !!');
      return;
    } else if (resp.statusCode == 401){
      ToolUt.msg(context, '因為長時間閒置, 系統已經離線, 請重新執行這個程式。');
      return;
    } else if (resp.statusCode >= 400){
      ToolUt.msg(context, 'Error: ${resp.reasonPhrase}!(${resp.statusCode})');
      return;
    }

    //show error msg if any
    var str = utf8.decode(resp.bodyBytes);
    var json2 = StrUt.toJson(str, showLog:false);
    var error = (json2 == null)
      ? _strToMsg(str)
      : _resultToMsg(json2);
    if (error != ''){
      ToolUt.msg(context, error);
      return;
    }

    //callback
    if (fnOk != null){
      fnOk(jsonOut ? json2 : str);
    }
  }

  ///result to error msg
  static String _resultToMsg(dynamic result){
    return (result['ErrorMsg'] == null)
        ? '' : _strToMsg(result['ErrorMsg']);
  }

  ///string to error msg
  static String _strToMsg(String str){
      return StrUt.isEmpty(str) ? '' :
        (str.substring(0, 2) == FunUt.preError) ? str.substring(2) :
        '';
  }

  /*
  //get public ip address
  static Future<String> getIp() async {
    if (isDev)
      return ':::1';

    var uri = Uri.https('api.ipify.org', '');
    var response = await http.get(uri);
    return (response.statusCode == 200)
        ? response.body
        : '';
  }
  */

} //class
