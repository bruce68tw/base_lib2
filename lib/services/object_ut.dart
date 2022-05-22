//static class, cannot use _Fun
class ObjectUt {

  static bool isEmpty(dynamic data) {
      return (data == null || data.ToString() == "");
  }

  static bool notEmpty(dynamic data) {
      return !isEmpty(data);
  }

} //class
