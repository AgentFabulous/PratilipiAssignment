// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

class CookieMonster {
  // 2592000 sec = 30 days.
  static addToCookie(String key, String value) =>
      document.cookie = "$key=$value; max-age=2592000; path=/;";

  static void deleteCookie(String key) =>
      document.cookie = "$key= ; expires = Thu, 01 Jan 1970 00:00:00 GMT";

  static String getCookie(String key) {
    String cookies = document.cookie;
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : List();
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }
}
