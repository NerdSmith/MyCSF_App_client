import 'package:mycsf_app_client/api/user.dart';

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
}