import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/myevent.dart';
import 'package:mycsf_app_client/views/eventview.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class MyCalendarView extends StatefulWidget {
  final Function redirectToLogin;

  const MyCalendarView({Key? key, required this.redirectToLogin}) : super(key: key);

  @override
  State<MyCalendarView> createState() => _MyCalendarViewState();
}

class _MyCalendarViewState extends State<MyCalendarView> {
  List<MyEvent> events = [];
  bool _render = false;

  @override
  void initState() {
    super.initState();
    Auth.getCurrentRole().then((value) {
      if (value == Role.unauthorized) {
        widget.redirectToLogin();
      } else {
        EventController.fetchAll4CurrUser().then((value) {
          setState(() {
            _render = true;
            events = value;
          });
        });
      }
    });

  }

  void openEventPage(MyEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(event: event),
      ),
    );
  }

  onItemTap(CalendarTapDetails details) {
    List? appointment = details.appointments;
    DateTime date = details.date!;
    CalendarElement element = details.targetElement;
    print("$date, $element, $appointment");

    if (element == CalendarElement.appointment && appointment!.isNotEmpty) {
      print("app");
      openEventPage(appointment.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _render ? Container(
      child: SfCalendar(
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center
        ),
        dataSource: _getCalendarDataSource(),
        onTap: onItemTap,
        view: CalendarView.month,
        firstDayOfWeek: 1,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 3,
          agendaViewHeight: 150,
          agendaItemHeight: 40,
          showAgenda: true,
        ),
      ),
    ) : Container();
  }

  CalendarDataSource<MyEvent> _getCalendarDataSource() {
    return _EventDataSource(events);
  }

}

class _EventDataSource extends CalendarDataSource<MyEvent> {
  _EventDataSource(List<MyEvent> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].getStartTime();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].getEndTime();
  }


  @override
  Color getColor(int index) {
    return appointments![index].getColor();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay();
  }
}