import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/auth.dart';

import '../api/apiconfig.dart';

class ChatUser {
  int id;
  String username;
  String firstName;
  String secondName;
  String patronymic;
  String? avatar;

  ChatUser(this.id, this.username, this.firstName, this.secondName,
      this.patronymic, this.avatar);

  @override
  String toString() {
    return "$username $firstName $secondName $patronymic";
  }

  fio() {
    return "$secondName $firstName $patronymic @$username";
  }
}

class ChatMessage {
  int messageId;
  int roomId;
  String messageContent;
  String fromMessageUser;
  String messageTime;

  ChatMessage({required this.messageId, required this.roomId, required this.messageContent,
    required this.fromMessageUser, required this.messageTime});

  @override
  String toString() {
    return 'ChatMessage{messageId: $messageId, roomId: $roomId, messageContent: $messageContent, fromMessageUser: $fromMessageUser, messageTime: $messageTime}';
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        messageId: json["message_id"],
        roomId: json["message_room"],
        messageContent: json["message_content"],
        fromMessageUser: json["message_user"],
        messageTime: json["message_created_at"]
    );
  }

  factory ChatMessage.fromJsonShort(Map<String, dynamic> json) {
    return ChatMessage(
        messageId: json["id"],
        roomId: json["room"],
        messageContent: json["content"],
        fromMessageUser: '${json["user"]}',
        messageTime: json["created_at"]
    );
  }
}

class ChatRoom {
  String username;
  int userId;
  String? avatar;
  String? first_name;
  String? second_name;
  String? patronymic;
  int roomId;
  String roomName;
  String lastMessage;
  int lastSentUser;

  ChatRoom(this.username, this.userId, this.avatar, this.first_name, this.second_name,
      this.patronymic, this.roomId, this.roomName,
      this.lastMessage, this.lastSentUser);
}

class UserCommonController {
  static Future<int> getSelfId() async {
    final response = await http.get(
      Uri.parse('$apiUrl/chat/users/selfid/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(utf8.decode(response.bodyBytes));
      return res["id"];
    }
    else {
      throw Exception("Cant receive selfid");
    }
  }


  static Future<List<ChatUser>> getUsersBySearch(String promt) async {
    final response = await http.get(
      Uri.parse('$apiUrl/chat/users/search/').replace(
        queryParameters: {
          "query" : promt
        }
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      List<ChatUser> users = [];
      List<Map<String, dynamic>> res =
      jsonDecode(utf8.decode(response.bodyBytes))['results'].cast<Map<String, dynamic>>();
      for (var u in res) {
        users.add(
            ChatUser(
                u["id"],
                u["username"],
                u["first_name"],
                u["second_name"],
                u["patronymic"],
                u["avatar"]
            )
        );
      }
      return users;
    }
    else {
      throw Exception("Cant receive user search");
    }
  }


  static Future<List<ChatRoom>> getChatRooms() async {
    final response = await http.get(
      Uri.parse('$apiUrl/chat/user-chatrooms/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      List<ChatRoom> rooms = [];
      List<Map<String, dynamic>> res =
      jsonDecode(utf8.decode(response.bodyBytes))['data'].cast<Map<String, dynamic>>();
      for (var u in res) {
        rooms.add(
            ChatRoom(
              u["user__username"],
              u["user__id"],
              u["user__avatar"],
              u["user__first_name"],
              u["user__second_name"],
              u["user__patronymic"],
              u["room__id"],
              u["room__name"],
              u["room__last_message"],
              u["room__last_sent_user"],
            )
        );
      }
      return rooms;
    }
    else {
      throw Exception("Cant receive chatrooms");
    }
  }

  static Future<List<ChatMessage>> getChatMessages(int target) async {
    final response = await http.get(
      Uri.parse('$apiUrl/chat/room-messages/$target/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      List<ChatMessage> messages = [];
      List<Map<String, dynamic>> res =
      jsonDecode(utf8.decode(response.bodyBytes))['data'].cast<Map<String, dynamic>>();
      for (var msg in res) {
        messages.add(ChatMessage.fromJsonShort(msg));
      }
      return messages;
    }
    else {
      throw Exception("Cant receive messages");
    }
  }
}