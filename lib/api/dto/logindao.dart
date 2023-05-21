
class LoginDao {
  String? username;
  String? password;

  LoginDao({this.username, this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}