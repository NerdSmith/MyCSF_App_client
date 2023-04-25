import 'package:mycsf_app_client/api/user.dart';

class Student extends User {
  String? year_of_enrollment;
  String? record_book_number;

  Student({
    String? username,
    String? password,
    String? first_name,
    String? second_name,
    String? patronymic,
    String? email,
    String? phone,
    this.year_of_enrollment,
    this.record_book_number
  }) : super(
      username: username,
      password: password,
      first_name: first_name,
      second_name: second_name,
      patronymic: patronymic,
      email: email,
      phone: phone
  );
}