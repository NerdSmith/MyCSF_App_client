import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/schedule.dart';
import 'package:table_calendar/table_calendar.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class ScheduleView extends StatefulWidget {
  final Function redirectToLogin;

  const ScheduleView({Key? key, required this.redirectToLogin})
      : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DateTime _selectedDate = DateTime.now();
  List<DaySchedule> _schedule = [];
  String _week = "";
  bool _isListOpen = false;
  bool _fullMode = false;

  _getCurrentScheduleByWeek(String week) {
    ScheduleController.getScheduleByWeek(week).then((value) {
      setState(() {
        _fullMode = true;
        _schedule = value;
        _week = week == "n" ? "Числитель" : "Знаменатель";
      });
    });

  }

  _getCurrentScheduleByDate() {
    ScheduleController.getScheduleByDay(
            _selectedDate)
        .then((value) {
      setState(() {
        _schedule = [value];
      });
    });
  }

  _isEqualDates(DateTime dt1, DateTime dt2) {
    return dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }

  _getCurrentWeekByDate() {
    ScheduleController.getDayInfo(_selectedDate).then((value) {
      setState(() {
        _week = value["week"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru', null).then((_) {});
    Auth.getCurrentRole().then((value) {
      if (value == Role.unauthorized) {
        widget.redirectToLogin();
      } else {
        _getCurrentScheduleByDate();
        _getCurrentWeekByDate();
      }
    });
  }

  _makeTimeText(String text) {
    return Container(
        constraints: BoxConstraints(minWidth: 50),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(text, style: Theme.of(context).textTheme.displayLarge),
        ));
  }

  _makeScheduleItem(ScheduleItem subject) {
    var isEmpty = false;
    if (subject.subjectName.isEmpty &&
        subject.classroom.isEmpty &&
        subject.professor.isEmpty) {
      isEmpty = true;
    }

    String subjectFullName = "${subject.subjectName}\n"
        "${subject.professor}\n"
        "${subject.classroom}";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
              constraints: BoxConstraints(minHeight: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _makeTimeText(subject.timeFrom),
                  _makeTimeText(subject.timeTo)
                ],
              )),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: isEmpty
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(minHeight: 100),
                      child: Text(
                        subjectFullName,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ))
        ],
      ),
    );
  }

  _makeFullDaySchedule(List<ScheduleItem> subjects) {
    if (subjects.isNotEmpty) {
      List<ScheduleItem> res = [];
      String start = subjects[0].timeFrom;
      // String startEnd = subjects[subjects.length - 1].timeFrom;
      var idxStart = timeRanges.indexWhere((element) {
        return element.start == start;
      });
      var timeIdx = idxStart;
      var subjIdx = 0;
      for (var i = 0; i < 10; i++) {
        if (timeIdx > timeRanges.length - 1 || subjIdx > subjects.length - 1) {
          break;
        }
        if (subjects[subjIdx].timeFrom == timeRanges[timeIdx].start) {
          res.add(subjects[subjIdx]);
          timeIdx += 1;
          subjIdx += 1;
        } else {
          res.add(ScheduleItem(
              timeFrom: timeRanges[timeIdx].start,
              timeTo: timeRanges[timeIdx].stop,
              subjectName: "",
              classroom: "",
              professor: ""));
          timeIdx += 1;
        }
      }
      return Column(
        children: [for (var item in res) _makeScheduleItem(item)],
      );
    }
    return Container();
  }

  _makeDayScheduleItem(DaySchedule daySchedule) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                weekdaysRu[daySchedule.weekday]!.capitalize(),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
        if (daySchedule.subjects.isEmpty)
          Container(
            constraints: BoxConstraints(minHeight: 100),
            child: Center(
                child: Text(
              "Пар нет",
              style: Theme.of(context).textTheme.displayLarge,
            )),
          ),
        // for (var item in daySchedule.subjects) _makeScheduleItem(item),
        _makeFullDaySchedule(daySchedule.subjects),
        Divider()
      ],
    );
  }

  Widget _makeButton(
      {required String text,
      required Function f,
      double paddingLeft = 0,
      double paddingRight = 0,
      double paddingBottom = 20}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: paddingLeft, right: paddingRight, bottom: paddingBottom),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD9D9D9),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(200, 50),
              elevation: 10,
              alignment: Alignment.center,
            ),
            onPressed: () {
              f();
            },
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
          ),
        ))
      ],
    );
  }

  _getTitleText() {
    if (_fullMode) {
      return _week.toUpperCase();
    }
    return "${_isEqualDates(_selectedDate, DateTime.now()) ? 'Сегодня' : ''} ${_week.toUpperCase()} "
        "${DateFormat('dd MMMM yyyy', 'ru').format(_selectedDate)}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 0),
                              child: _makeButton(
                                  text: _getTitleText(),
                                  paddingBottom: 10,
                                  f: () {
                                    setState(() {
                                      _isListOpen = !_isListOpen;
                                    });
                                  }))))),
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                  child: Container(
                    color: Colors.white,
                    child: Divider(
                      color: Colors.black,
                    ),
                  )),
              AnimatedCrossFade(
                  firstChild: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1.0))),
                    child: SingleChildScrollView(
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _makeButton(text: "Сегодня", f: () {
                                        setState(() {
                                          _fullMode = false;
                                          _selectedDate = DateTime.now();
                                        });
                                        _getCurrentScheduleByDate();
                                        _getCurrentWeekByDate();
                                      }),
                                      TableCalendar(
                                        locale: 'ru_RU',
                                        startingDayOfWeek: StartingDayOfWeek.monday,
                                        selectedDayPredicate: (day) {
                                          return isSameDay(_selectedDate, day);
                                        },
                                        onDaySelected: (selectedDay, focusedDay) {
                                          setState(() {
                                            _fullMode = false;
                                            _selectedDate = selectedDay;
                                          });
                                          _getCurrentScheduleByDate();
                                          _getCurrentWeekByDate();
                                        },
                                        focusedDay: DateTime.now(),
                                        firstDay: DateTime.utc(2021, 1, 1),
                                        lastDay: DateTime.utc(2025, 1, 1),
                                      ),
                                      Row(

                                        children: [
                                          Expanded(
                                            child: _makeButton(text: "Числитель", f: (){
                                              _getCurrentScheduleByWeek("n");
                                            }),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: _makeButton(text: "Знаменатель", f: (){
                                              _getCurrentScheduleByWeek("d");
                                            }),
                                          )
                                        ],
                                      )
                                    ]
                                )
                            )
                        )
                    ),
                  ),
                  secondChild: Container(),
                  crossFadeState: _isListOpen
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300)),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var daySchedule in _schedule)
                          _makeDayScheduleItem(daySchedule)
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
