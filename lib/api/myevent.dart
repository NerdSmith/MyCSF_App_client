import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

import 'apiconfig.dart';
import 'auth.dart';

class MyEvent {
  String title;
  String description;
  String eventStartDatetime;
  String eventEndDatetime;
  bool isFullDay;
  String eType;

  MyEvent(
      {required this.title,
      required this.description,
      required this.eventStartDatetime,
      required this.eventEndDatetime,
      required this.isFullDay,
      required this.eType});

  DateTime getStartTime() {
    return DateTime.parse(eventStartDatetime);
  }

  DateTime getEndTime() {
    return DateTime.parse(eventEndDatetime);
  }

  Color getColor() {
    switch (eType) {
      case 'i':
        return const Color(0xFF0082C5);
      case 'a':
        return const Color(0xFFFF4646);
      case 'e':
        return const Color(0xFF000000);
      case 'h':
        return const Color(0xFF1EA200);
      default:
        return const Color(0xFF188EC9);
    }
  }

  bool isAllDay() {
    return isFullDay;
  }
}

class EventController {
  static Future<List<MyEvent>> fetchAll4CurrUser() async {
    var headers = {
    'Content-Type': 'application/json',
    };

    try {
      var auth = await Auth.getAuthStr();
      headers["Authorization"] = auth;
    }
    catch (e) {
      print(e);
    }

    final response = await http.get(
      Uri.parse('$apiUrl/api/event/'),
      headers: headers
    );
    if (response.statusCode == 200) {
      List<MyEvent> events = [];
      var decoded = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in decoded) {
        events.add(
            MyEvent(
              title: item["title"],
              description: item["description"],
              eventStartDatetime: item["event_start_datetime"],
              eventEndDatetime: item["event_end_datetime"],
              isFullDay: item["is_full_day"],
              eType: item["e_type"]
            )
        );
      }
      return events;
    }
    else {
      throw Exception("Cant receive events");
    }
  }
}


