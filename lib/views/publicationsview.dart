import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mycsf_app_client/api/myevent.dart';
import 'package:mycsf_app_client/api/publication.dart';
import 'package:mycsf_app_client/views/eventview.dart';
import 'package:mycsf_app_client/views/mypublicationview.dart';

import '../api/auth.dart';

class PublicationsView extends StatefulWidget {
  final Function redirectToCalendar;

  const PublicationsView({Key? key, required this.redirectToCalendar})
      : super(key: key);

  @override
  State<PublicationsView> createState() => _PublicationsViewState();
}

class _PublicationsViewState extends State<PublicationsView> {
  final PublicationBloc _publicationBloc = PublicationBloc();
  ScrollController _scrollController = ScrollController();
  bool _isFetching = false;
  List<MyEvent> _events = [];
  bool _isAuth = false;
  bool _isEventsOpen = true;

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Publications Page opened');
    _publicationBloc.fetchPubs();
    _scrollController.addListener(_scrollListener);
    EventController.fetchAll4CurrUser(latest: true).then((value) {
      setState(() {
        _events = value.length >= 2 ? value.sublist(0, 2) : value;
      });
    });
    Auth.getCurrentRole().then((value) {
      if (value != Role.unauthorized) {
        setState(() {
          _isAuth = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _publicationBloc.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      if (!_isFetching) {
        _isFetching = true;
        _publicationBloc.fetchPubs().then((_) {
          _isFetching = false;
        });
      }
    }
    if (_scrollController.position.pixels != 0) {
      if (_isEventsOpen) {
        setState(() {
          _isEventsOpen = false;
        });
      }
    }
    if (_scrollController.position.pixels == 0) {
      if (!_isEventsOpen) {
        setState(() {
          _isEventsOpen = true;
        });
      }
    }
  }

  void openPabPage(Publication pub) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPublicationView(publication: pub),
      ),
    );
  }

  void openEventPage(MyEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
            firstChild: Column(
              children: [
                for (var e in _events)
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        openEventPage(e);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: e.getColor(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                              child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: DelayedScrollingText(
                              text:
                                  "${DateFormat('d MMM y HH:mm', 'ru').format(e.getStartTime())} ${e.title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(color: Colors.white),
                              delayDuration: Duration(seconds: 5),
                            ),
                          ))),
                    ),
                  ),
                if (_isAuth)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        widget.redirectToCalendar();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all()),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 5, bottom: 5),
                          child: Text("Ещё"),
                        ),
                      ),
                    )),
                  ),
                Padding(
                    padding: EdgeInsets.only(bottom: 0, top: 10),
                    child: Container(
                      // color: Colors.white,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 1.0))),
                    )),
              ],
            ),
            secondChild: Container(),
            crossFadeState: _isEventsOpen
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 1000)),
        Expanded(
            child: BlocBuilder<PublicationBloc, List<Publication>>(
                bloc: _publicationBloc,
                builder: (context, pubList) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: pubList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < pubList.length) {
                        final pubs = pubList[index];
                        return Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, right: 20, bottom: 0),
                            child: GestureDetector(
                              onTap: () {
                                openPabPage(pubs);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    if (pubs.image != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, right: 20, left: 20),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl: pubs.image!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )),
                                      ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                              bottom: 10,
                                              right: 20),
                                          child: Text(
                                            pubs.title!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        )),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 20, bottom: 5),
                                        child: Text(
                                          pubs.getDatetimeRepr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Color(0xFFD9D9D9),
                          )),
                        );
                      }
                    },
                  );
                }))
      ],
    );
  }
}
