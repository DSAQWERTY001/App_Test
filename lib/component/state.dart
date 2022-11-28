import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  static String user = "";
  static String pass = "";
  static bool check = false;
  static String userName = "";

  static void setUsername(String val) {
    user = val;
  }

  static void setUsernameLoggedin(String val) {
    userName = val;
  }

  static void setCheckUser(bool val) {
    check = val;
  }

  static void setPassword(String val) {
    pass = val;
  }

  static String getUsername() {
    return user;
  }

  static String getUsernameLoggedin() {
    return userName;
  }

  static String getPassword() {
    return pass;
  }

  static bool getCheckUser() {
    return check;
  }
}

class Provider {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('loginSuccess') ?? false;
  }

  Future<bool> logout() async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.clear();
  }
}
