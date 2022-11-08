
//static class, cannot use _Fun
class BoolUt {

  //boolean to int
  static int toInt(bool? value) {
    return (value == null) ? 0 :
      value ? 1 : 0;
  }

} //class
