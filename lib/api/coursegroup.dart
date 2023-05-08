import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/apiconfig.dart';

class CourseGroup {
  final int id;
  final int courseNumber;
  final String groupNumber;
  final String higherEducationLevel;

  static const Map<String, String> EDUCATION_LEVELS_RU = {
    'b': "бакалавриат",
    'm': "магистратура",
    'p': "аспирантура",
    's': "специалитет"
  };

  CourseGroup(
    {required this.id,
    required this.courseNumber,
    required this.groupNumber,
    required this.higherEducationLevel}
  );


  @override
  String toString() {
    String edLvl = EDUCATION_LEVELS_RU[higherEducationLevel]!;
    return '$courseNumber курс $groupNumber группа $edLvl';
  }

  factory CourseGroup.fromJson(Map<String, dynamic> json) {
    return CourseGroup(
      id: json["id"],
      courseNumber: json["course_number"],
      groupNumber: json["group_number"],
      higherEducationLevel: json["higher_education_level"]
    );
  }

  static List<CourseGroup> parse(String stringData) {
    final parsed = json.decode(stringData).cast<Map<String, dynamic>>();

    return parsed.map<CourseGroup>((json) => CourseGroup.fromJson(json)).toList();
  }

  static Future<List<CourseGroup>> fetchAll() async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/courseGroup/')
    );
    if (response.statusCode == 200) {
      final data = parse(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}