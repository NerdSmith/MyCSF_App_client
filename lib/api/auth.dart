import 'dart:convert';

import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:mycsf_app_client/api/jwt.dart';
import 'package:mycsf_app_client/api/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


enum Role {
  unauthorized,
  student,
  professor
}

Map<String, Role> RoleMapping = {
  "s": Role.student,
  "p": Role.professor,
  "n": Role.unauthorized
};

extension RoleExtension on Role {
  String toStringValue() {
    return toString().split('.').last;
  }

  static Role fromStringValue(String value) {
    return Role.values.firstWhere((e) => e.toString().split('.').last == value);
  }
}

class Auth {
  static const roleKey = "auth_role";

  static Map<Role, String> rolesMap = {
    Role.unauthorized: "Неавторизован",
    Role.student: "Студент",
    Role.professor: "Преподаватель",
  };

  static Future<void> performAuthCheck() async {
    bool isAccessValid = await Jwt.verify();
    print("is Access Valid: $isAccessValid");
    if (!isAccessValid) {
      // TODO: try refresh
      // else -> unauthorized
      try {
        String newToken = await Jwt.refresh();
        print("using refresh");
        // access token set
      }
      catch (e) {
        setRole(Role.unauthorized);
        print("using unauthorized");
      }
    }
  }

  static Future<void> performLogout() async {
    Jwt.deleteTokens();
    Auth.setRole(Role.unauthorized);
  }

  static Future<Role> getRole() async {
    try {
      User u = await getUserInfo();
      print("role login set: ${u.role}", );
      return RoleMapping[u.role]!;
    }
    catch (e) {
      throw Exception("Cant receive User obj");
    }
  }

  static Future<User> getUserInfo() async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/auth/users/shortinfo/0/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    else {
      throw Exception("Cant receive User obj");
    }
  }

  static Future<bool> updateUserInfo({
    String first_name = "",
    String second_name = "",
    String patronymic = "",
    String email = "",
    String phone = "",
}) async {
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$apiUrl/api/users/avatars/-1/'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': await Auth.getAuthStr()
    });

    request.fields["first_name"] = first_name;
    request.fields["second_name"] = second_name;
    request.fields["patronymic"] = patronymic;
    request.fields["email"] = email;
    request.fields["phone"] = phone;

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      dynamic data = jsonDecode(utf8.decode((await response.stream.bytesToString()).runes.toList()));
      throw Exception(data);
    }
  }

  static Future<bool> isUnauthorized() async {
    return await getCurrentRole() == Role.unauthorized;
  }

  static Future<Role> getCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    String? rolestr = prefs.getString(roleKey);
    if (rolestr == null) {
      return Role.unauthorized;
    }
    return RoleExtension.fromStringValue(rolestr);
  }

  static Future<void> setRole(Role role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(roleKey, role.toStringValue());
  }

  static Future<String> getAuthStr() async {
    String? token = await Jwt.getAccess();
    if (token != null) {
      return "Bearer $token";
    }
    throw Exception("Access dosn't set!");
  }

  static String getFullName(
      String? secondName,
      String? firstName,
      String? patronymic
      ) {
    if (firstName == null || secondName == null || patronymic == null) {
      return "<Ваше ФИО>";
    }
    String fnInitials = firstName.substring(0, 1);
    String pInitials = patronymic.substring(0, 1);
    return "$secondName $fnInitials. $pInitials.";
  }

  static String getRoleStr(Role? role) {
    if (role == null) {
      return "";
    }
    return rolesMap[role]!;
  }
}