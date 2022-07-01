//import 'package:device_info/device_info.dart';
import 'package:geolocator/geolocator.dart';

import '../models/gps_dto.dart';

//static class, cannot use _Fun
class DeviceUt {

  /*
  //get device id
  static Future<String> getId() async {
    var info = await DeviceInfoPlugin().androidInfo;
    //var info = await DeviceInfoPlugin().iosInfo; //ios
    return info.androidId;
  }
  */

  /// get gps position
  /// tailLen: 經緯度小數點後面字串長度, 不指定則使用預設
  static Future<GpsDto> getGpsAsync([int? tailLen]) async {
    var status = await Geolocator.isLocationServiceEnabled();
    if (status) {
      var auth = await Geolocator.checkPermission();
      if (auth == LocationPermission.denied) {
        auth = await Geolocator.requestPermission();
        if (auth == LocationPermission.denied) {
            return GpsDto(error: 'GPS Permission denied.');
        } else if (auth == LocationPermission.deniedForever){
            return GpsDto(error: 'GPS Permission deniedForever.');
        }
      }

      var pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var lat = pos.latitude.toString();
      var long = pos.longitude.toString();
      if (tailLen != null){
        lat = _cutTail(lat, '.', tailLen);
        long = _cutTail(long, '.', tailLen);
      }
      return GpsDto(longitude: long, latitude: lat);
    } else {
      return GpsDto(error: 'GPS Service Disabled.');
    }
  }

  static String _cutTail(String source, String find, int tailLen) {
    var pos = source.indexOf(find);
    if (pos < 0) return source;

    return (source.substring(pos).length <= tailLen) 
      ? source
      : source.substring(0, pos + tailLen + 1);
  }

} //class
