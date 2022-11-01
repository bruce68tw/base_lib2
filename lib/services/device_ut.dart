//import 'package:device_info/device_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
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

      //高精度會使用高耗能
      var pos = await isAirplaneModeAsync()
        ? await Geolocator.getLastKnownPosition()
        : await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      if (pos == null){
        return GpsDto(error: 'Airplane mode ON !!');
      }

      var lat = pos.latitude.toString();
      var long = pos.longitude.toString();
      if (tailLen != null){
        lat = _gpsCutTail(lat, '.', tailLen);
        long = _gpsCutTail(long, '.', tailLen);
      }
      return GpsDto(longitude: long, latitude: lat);
    } else {
      return GpsDto(error: 'GPS Service Disabled.');
    }
  }

  static String _gpsCutTail(String source, String find, int tailLen) {
    var pos = source.indexOf(find);
    if (pos < 0) return source;

    return (source.substring(pos).length <= tailLen) 
      ? source
      : source.substring(0, pos + tailLen + 1);
  }

  /// 是否開啟飛航模式
  static Future<bool> isAirplaneModeAsync() async {
    var status = await AirplaneModeChecker.checkAirplaneMode();
    return (status == AirplaneModeStatus.on);
  }

} //class
