import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/user.dart';


class AvatarService {
  static Future<String?> fetchAvatar() async {
    try {
      User u = await Auth.getUserInfo();
      return u.avatar;
    }
    catch (e) {
     return null;
    }
  }

  static Future<String?> uploadAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      var request = http.MultipartRequest(
          'PATCH',
          Uri.parse('$apiUrl/api/users/avatars/-1/'),

      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      });
      request.files.add(await http.MultipartFile.fromPath('avatar', file.path!));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseJson = await http.Response.fromStream(response);

        var data = json.decode(responseJson.body);
        var newAvatarUrl = data['avatar'];
        return newAvatarUrl;
      } else {
        throw Exception("Ошибка загрузки");
      }
    }
    throw Exception("Ошибка загрузки");
  }
}