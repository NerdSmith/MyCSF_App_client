import 'dart:convert';

import 'apiconfig.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';


class GPTMessage {
  final String content;
  final bool isUser;

  GPTMessage({required this.content, required this.isUser});
}

class GPTController {
  static Future<GPTMessage> getAnswer(GPTMessage question) async {
    final response = await http.post(
        Uri.parse('$apiUrl/api/chatBot/getAnswer'),
        body: {
          "text": question.content
        },
        headers: {
          "Authorization": await Auth.getAuthStr()
        }
    );

    if (response.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return GPTMessage(content: decoded["answer"].toString().trim(), isUser: false);
    }
    else {
      var decoded = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception("$decoded");
    }
  }
}