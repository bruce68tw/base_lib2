//map to server side
class ItemOpEstr {

  //=== same as sql op ===
  static const equal = "Equal";
  static const like = "Like";
  static const notLike = "NotLike";

  //input list as: u01,u02,...multiple in query for one field
  //backend will replace carrier line to comma for TextArea field
  static const in_ = "In";


  //=== not same as sql op ===
  //%xxx% compare
  static const like2 = "Like2";

  //input list as: u01,u02,... multiple like query for one field
  static const likeList = "LikeList";

  //input one String, do like query for multiple columns(set Col field)
  static const likeCols = "LikeCols";

  //do like('%xxx%') query for multiple columns(set Col and seperate with comma)
  static const like2Cols = "Like2Cols";

  static const is_ = "Is";
  static const isNull = "IsNull";
  static const notNull = "NotNull";
  static const inRange = "InRange";

  //PG defined
  static const userDefined = "UD";

}

