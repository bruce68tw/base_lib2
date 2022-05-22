//import 'dart:developer';
import 'dart:convert';  //for utf8
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';  //for AES
import 'package:crypto/crypto.dart';    //for sha1
import 'package:convert/convert.dart';  //for hex
import 'log_ut.dart';  

//static class
class StrUt {
  ///pre error, 2 chars
  static const preError = 'E:';

  static bool isEmpty(String? str) {
    return (str == null || str == '');
  }

  static bool notEmpty(String? str) {
    return !isEmpty(str);
  }

  static String getError(String msg) {
    return preError + msg;
  }

  ///check & get error msg if any
  static String checkError(String msg) {
    return isEmpty(msg)
        ? ''
        : msg.substring(0, 2) == preError
            ? msg.substring(2)
            : '';
  }

  static String addNum(String str, int num) {
    return (int.parse(str) + num).toString();
  }

  static String preZero(int len, String str, [bool? matchLen]) {
    matchLen ??= false;
    return (str.length < len)
        ? str.padLeft(len, '0')
        : matchLen
            ? str.substring(0, len)
            : str;
  }

  static String utf8Decode(String str) {
    //List<int> bytes = utf8.encode(str);
    return const Utf8Decoder().convert(utf8.encode(str));
  }

  //AES encode, data:plain text
  static String aesEncode(String data, String aesKey) {
    //var aesKey = preZero(16, await FunHp.getIp(), true);
    //var aesKey = getAesKey();
    final key = Key.fromUtf8(aesKey);
    final iv = IV.fromUtf8(aesKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));
    return encrypter.encrypt(data, iv: iv).base64;
  }

  //AES decode, data:encoded base64 string
  static String aesDecode(String data, String aesKey) {
    //var aesKey = await FunHp.getIp();
    //var aesKey = getAesKey();
    final key = Key.fromUtf8(aesKey);
    final iv = IV.fromUtf8(aesKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));
    return encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);
  }

  static Map<String, dynamic>? toJson(String data, {bool showLog = true}) {
    try {
      return jsonDecode(data);
    } on Exception catch (e) {
      if (showLog) LogUt.error('Error: $e');
      return null;
    }
  }
  
  static int findArray(List<String> list, String value) {
    return list.indexOf(value);
  }
  
  static String uuid() {
    return const Uuid().v4();
  }
  
  static String getLeft(String source, String find)
  {
      var pos = source.indexOf(find);
      return (pos < 0) ? source : source.substring(0, pos);
  }

  /// new row.id 10 char
  static String newId() {
      //1.stop 1 milli second for avoid repeat(sync way here !!)
      sleep(const Duration(milliseconds: 1));

      var num = DateTime.now().millisecondsSinceEpoch * 3;
      var bytes = utf8.encode(num.toString());
      var hexStr = sha1.convert(bytes).toString();
      return base64.encode(hex.decode(hexStr))
        .replaceAll('+', '').replaceAll('/', '')
        .substring(0, 10);
  }

}//class
