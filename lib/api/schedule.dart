import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mycsf_app_client/api/auth.dart';

import 'apiconfig.dart';
import 'package:http/http.dart' as http;

const weekdaysRu = {
  "sunday": "воскресенье",
  "monday": "понедельник",
  "tuesday": "вторник",
  "wednesday": "среда",
  "thursday": "четверг",
  "friday": "пятница",
  "saturday": "суббота",
};

class TimeRange {
  String start;
  String stop;

  TimeRange(this.start, this.stop);
}

List<TimeRange> timeRanges = [
  TimeRange("8:00", "9:35"),
  TimeRange("9:45", "11:20"),
  TimeRange("11:30", "13:05"),
  TimeRange("13:25", "15:00"),
  TimeRange("15:10", "16:45"),
  TimeRange("16:55", "18:30"),
  TimeRange("18:40", "20:00"),
  TimeRange("20:10", "21:30"),
];

class ScheduleItem {
  String timeFrom;
  String timeTo;
  String subjectName;
  String classroom;
  String professor;

  ScheduleItem({
    required this.timeFrom,
    required this.timeTo,
    required this.subjectName,
    required this.classroom,
    required this.professor
  });

  @override
  String toString() {
    return 'ScheduleItem{timeFrom: $timeFrom, timeTo: $timeTo, subjectName: $subjectName, classroom: $classroom, professor: $professor}';
  }
}

class DaySchedule {
  String weekday;
  List<ScheduleItem> subjects = [];

  DaySchedule(this.weekday);

  @override
  String toString() {
    return 'DaySchedule{weekday: $weekday, subjects: $subjects}';
  }
}

class ScheduleController {
  static Future<Map<String, dynamic>> getDayInfo(DateTime day) async {
    var url = Uri.parse('$apiUrl/api/dateInfo').replace(
        queryParameters: {"date": DateFormat('d-M-y').format(day)}
    );
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    else {
      throw Exception("Cant get date info: ${response.statusCode}");
    }
  }

  static Future<dynamic> getSchedule(DateTime? day, String? week) async {
    var url = Uri.parse('$apiUrl/api/schedule/0/');
    Map<String, dynamic> queryParams = {};
    if (day != null) {
      queryParams["day"] = DateFormat('d-M-y').format(day);
    }
    if (week != null) {
      queryParams["week"] = week;
    }

    final response = await http.get(
      url.replace(
          queryParameters: queryParams
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      if (response.bodyBytes.isNotEmpty) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      else {
        return null;
      }
    }
    else {
      throw Exception("Cant get schedule: ${response.statusCode}");
    }
  }

  static String getWeekday(DateTime date) {
    DateFormat formatter = DateFormat('EEEE');
    return formatter.format(date);
  }

  static Future<DaySchedule> getScheduleByDay(DateTime day) async {
    var jsonRes = await getSchedule(day, null);
    DaySchedule daySchedule = DaySchedule(getWeekday(day).toLowerCase());

    if (jsonRes == null) {
      return daySchedule;
    }

    List<ScheduleItem> scheduleItems = [];
    for (var item in jsonRes) {
      if (item.isEmpty) {
        break;
      }
      ScheduleItem scheduleItem = ScheduleItem(
        timeFrom: item['timeFrom'],
        timeTo: item['timeTo'],
        subjectName: item['subjectName'],
        classroom: item['classroom'],
        professor: item['professor']
      );
      scheduleItems.add(scheduleItem);
    }
    daySchedule.subjects = scheduleItems;
    return daySchedule;
  }

  static Future<List<DaySchedule>> getScheduleByWeek(String? week) async {
    var jsonRes = await getSchedule(null, week);
    List<DaySchedule> weekSchedule = [];

    if (jsonRes == null) {
      return weekSchedule;
    }
    (jsonRes as Map).forEach((key, value) {
      String weekday = key;
      DaySchedule daySchedule = DaySchedule(weekday);
      List<ScheduleItem> scheduleItems = [];

      for (var item in value) {
        if (item.isEmpty) {
          break;
        }
        ScheduleItem scheduleItem = ScheduleItem(
            timeFrom: item['timeFrom'],
            timeTo: item['timeTo'],
            subjectName: item['subjectName'],
            classroom: item['classroom'],
            professor: item['professor']
        );
        scheduleItems.add(scheduleItem);
      }
      daySchedule.subjects = scheduleItems;
      weekSchedule.add(daySchedule);
    });

    return weekSchedule;
  }
}