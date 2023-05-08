import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Jwt {
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      '$apiUrl/login' as Uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      await _saveToken(token);
      return token;
    }
    else {
      throw Exception('Failed to register');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}