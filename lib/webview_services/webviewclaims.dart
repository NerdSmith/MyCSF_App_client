import 'package:mycsf_app_client/webview_services/logpassclaims.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WebViewClaims {
  String loginField = "";
  String passwordField = "";

  Future<void> saveLogPass(LogPassClaims logPassClaims) async {
    final prefs = await SharedPreferences.getInstance();
    if (logPassClaims.login != null && logPassClaims.password != null) {
      await prefs.setString(loginField, logPassClaims.login!);
      await prefs.setString(passwordField, logPassClaims.password!);
    }
    else {
      throw Exception("Logpass not set");
    }
  }

  Future<LogPassClaims?> getLogPassClaims() async {
    final prefs = await SharedPreferences.getInstance();
    var login =  prefs.getString(loginField);
    var password =  prefs.getString(passwordField);
    if (login == null || password == null) {
      // await prefs.setString(loginField, "");
      // await prefs.setString(passwordField, "");
      return null;
    }
    var logPass = LogPassClaims();
    logPass.login = login;
    logPass.password = password;
    return logPass;
  }
}