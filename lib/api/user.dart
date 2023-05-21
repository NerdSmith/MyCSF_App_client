class User {
  String? username;
  String? password;
  String? first_name;
  String? second_name;
  String? patronymic;
  String? email;
  String? phone;
  String? role;
  String? avatar;

  User({this.username, this.password, this.first_name, this.second_name,
      this.patronymic, this.email, this.phone, this.role, this.avatar});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'first_name': first_name,
    'second_name': second_name,
    'patronymic': patronymic,
    'email': email,
    'phone': phone,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: null,
      first_name: json['first_name'],
      second_name: json['second_name'],
      patronymic: json['patronymic'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      avatar: json['avatar']
    );
  }
}