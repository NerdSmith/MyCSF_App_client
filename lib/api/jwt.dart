import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Jwt {
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/auth/jwt/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      print("login - ok");
      final body = jsonDecode(response.body);
      final refresh = body['refresh'];
      final access = body['access'];
      await _saveAccess(access);
      await _saveRefresh(refresh);
      return access;
    }
    else {
      print("login - failed");
      throw Exception('Failed to register');
    }
  }

  static Future<String> refresh({String? refresh}) async {
    refresh ??= await getRefresh();
    final response = await http.post(
      Uri.parse('$apiUrl/api/auth/jwt/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refresh': refresh
      }),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final access = body['access'];
      await _saveAccess(access);
      return access;
    }
    else {
      throw Exception('Failed to register');
    }
  }

  static Future<bool> verify({String? token}) async {
    token ??= await getAccess();
    final response = await http.post(
      Uri.parse('$apiUrl/api/auth/jwt/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  static Future<String?> getAccess() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  static Future<String?> getRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh');
  }

  static Future<void> _saveAccess(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access', token);
  }

  static Future<void> _saveRefresh(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh', token);
  }

  static Future<void> deleteTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
  }
}