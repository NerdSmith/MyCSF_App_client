class User {
  String? username;
  String? password;
  String? first_name;
  String? second_name;
  String? patronymic;
  String? email;
  String? phone;

  User({this.username, this.password, this.first_name, this.second_name,
      this.patronymic, this.email, this.phone});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'first_name': first_name,
    'second_name': second_name,
    'patronymic': patronymic,
    'email': email,
    'phone': phone,
  };
}