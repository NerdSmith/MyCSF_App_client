import 'dart:convert';

import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:mycsf_app_client/api/user.dart';
import 'package:http/http.dart' as http;

class Student extends User {
  String? year_of_enrollment;
  String? record_book_number;
  int? course_group_id;

  Student({
    String? username,
    String? password,
    String? first_name,
    String? second_name,
    String? patronymic,
    String? email,
    String? phone,
    this.year_of_enrollment,
    this.record_book_number,
    this.course_group_id
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
    'year_of_enrollment': year_of_enrollment,
    'record_book_number': record_book_number,
    'course_group_id': course_group_id,
  };

  static Future<String> createStudent(Student s) async {
    String jsonStudent = jsonEncode(s.toJson());
    print(jsonStudent);
    final response = await http.post(
        Uri.parse('$apiUrl/api/auth/users/students/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonStudent
    ).timeout(const Duration(seconds: 5));
    if (response.statusCode == 201) {
      // dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      return "OK";
    } else {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(data);
    }
  }
}