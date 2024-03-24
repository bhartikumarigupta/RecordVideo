import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static const String _loginKey = 'loginStatus';

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }
}
