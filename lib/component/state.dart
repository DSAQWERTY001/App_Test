class GlobalValues {
  static String user = "";
  static String pass = "";
  static bool check = false;

  static void setUsername(String val) {
    user = val;
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

  static String getPassword() {
    return pass;
  }

  static bool getCheckUser() {
    return check;
  }
}
