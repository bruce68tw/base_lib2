//static class
class LogTimeUt {

  //instance variables
  static DateTime? _start;

  //initial
  static void init(){
      _start = DateTime.now();
  }

  //log time
  static int getMiniSec([bool reset = false]){
      //var now = DateTime.now();
      var result = DateTime.now().difference(_start!).inMilliseconds;
      if (reset) init();      
      return result;
  }

} //class
