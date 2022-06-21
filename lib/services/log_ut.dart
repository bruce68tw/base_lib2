import 'dart:developer';

//static class, cannot use _Fun
class LogUt {

  static void info(String msg) {
    log('info: $msg');
  }

  static void error(String msg) {
    log('Error: $msg');
  }

} //class
