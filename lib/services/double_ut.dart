
//static class, cannot use _Fun
class DoubleUt {

  static String zeroToEmpty(double? value) {
    return (value == null || value == 0)
      ? '' : value.toString();
  }
} //class
