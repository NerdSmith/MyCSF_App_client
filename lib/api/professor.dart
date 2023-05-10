import 'dart:convert';

import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:mycsf_app_client/api/user.dart';
import 'package:http/http.dart' as http;

class Professor extends User {
  String? department;

  Professor({
    String? username,
    String? password,
    String? first_name,
    String? second_name,
    String? patronymic,
    String? email,
    String? phone,
    this.department
  }) : super(
      username: username,
      password: password,
      first_name: first_name,
      second_name: second_name,
      patronymic: patronymic,
      email: email,
      phone: phone
  );

  Map<String, dynamic> toJson() => {
    'user': super.toJson(),
    'department': department,
  };

  static Future<dynamic> createProfessor(Professor p) async {
    String jsonProfessor = jsonEncode(p.toJson());
    print(jsonProfessor);
    final response = await http.post(
      Uri.parse('$apiUrl/api/auth/users/professors/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonProfessor
    ).timeout(const Duration(seconds: 5));
    if (response.statusCode == 201) {
      // dynamic data = jsonDecode(response.body);
      return "OK";
    } else {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(data);
    }
  }
}