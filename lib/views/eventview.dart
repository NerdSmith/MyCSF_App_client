import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:mycsf_app_client/api/myevent.dart';
import 'package:mycsf_app_client/backappbar.dart';
import 'package:url_launcher/url_launcher.dart';

class EventView extends StatefulWidget {
  final MyEvent event;

  const EventView({Key? key, required this.event}) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {

  _makeTextOutField(String text) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                      child: Linkify(
                          text: text,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.left,
                          onOpen: (link) async {
                            if (await canLaunchUrl(Uri.parse(link.url))) {
                              await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                      )
                    )
                  ],
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    String startDateTime = DateFormat('d MMM y HH:mm', 'ru').format(widget.event.getStartTime());
    String endDateTime = DateFormat('d MMM y HH:mm', 'ru').format(widget.event.getEndTime());

    String formattedDate = startDateTime == endDateTime ? startDateTime : "$startDateTime - $endDateTime";
    String isFullDay = widget.event.isAllDay() ? "Весь день" : "";

    String fullDateInfo = "$formattedDate $isFullDay";

    return Scaffold(
        appBar: const BackAppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(15.0),
                      right: Radius.circular(15.0),
                    ),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Color(0xFFEDEDED),
                          border: Border(
                            right: BorderSide(
                              color: widget.event.getColor(),
                              width: 25.0,
                              style: BorderStyle.solid,
                            ),
                            left: BorderSide(
                              color: widget.event.getColor(),
                              width: 25.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Container(
                            child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: DelayedScrollingText(
                            text: widget.event.title,
                            style: Theme.of(context).textTheme.displayLarge,
                            delayDuration: Duration(seconds: 5),
                          ),
                        ))),
                  ),
                  _makeTextOutField(fullDateInfo),
                  _makeTextOutField(widget.event.description)
                ],
              ),
            ),
          ),
        ));
  }
}

class DelayedScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration delayDuration;

  const DelayedScrollingText({
    Key? key,
    required this.text,
    required this.style,
    required this.delayDuration,
  }) : super(key: key);

  @override
  _DelayedScrollingTextState createState() => _DelayedScrollingTextState();
}

class _DelayedScrollingTextState extends State<DelayedScrollingText> {
  ScrollController _scrollController = ScrollController();

  Future<void> animate() async {
    for (int i = 0; i < 4; i++) {
      await Future.delayed(widget.delayDuration, () {
        if (_scrollController.positions.isNotEmpty) {
          _scrollController
              .animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 5),
            curve: Curves.easeOut,
          )
              .then((value) {
            if (_scrollController.positions.isNotEmpty) {
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
