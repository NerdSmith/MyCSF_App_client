import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mycsf_app_client/api/myevent.dart';
import 'package:mycsf_app_client/api/publication.dart';
import 'package:mycsf_app_client/backappbar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eventview.dart';

class MyPublicationView extends StatefulWidget {
  final Publication publication;

  const MyPublicationView({Key? key, required this.publication})
      : super(key: key);

  @override
  State<MyPublicationView> createState() => _MyPublicationViewState();
}

class _MyPublicationViewState extends State<MyPublicationView> {
  MyEvent? _linkedEvent;

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Publication Page opened');
    if (widget.publication.event != null) {
      EventController.getEventById(widget.publication.event!).then((value) {
        setState(() {
          _linkedEvent = value;
        });
      }).catchError((err){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Невозможно получить прикрепленное событие: $err'),
          ),
        );
      });
    }

  }

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
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: Linkify(
                          text: text,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.left,
                          onOpen: (link) async {
                            if (await canLaunchUrl(Uri.parse(link.url))) {
                              await launchUrl(Uri.parse(link.url),
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                        ))
                  ],
                ))));
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
    return Scaffold(
      appBar: const BackAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: DelayedScrollingText(
                        text: widget.publication.title!,
                        style: Theme.of(context).textTheme.displayLarge,
                        delayDuration: Duration(seconds: 5),
                      ),
                    ),
                  ),
                ),
                widget.publication.image != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: widget.publication.image!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      )
                    : Container(),
                _makeTextOutField(widget.publication.getDatetimeRepr()),
                _makeTextOutField(widget.publication.bodyText!),
                _linkedEvent != null ?
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {openEventPage(_linkedEvent!);},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ClipRRect(
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
                                    color: _linkedEvent!.getColor(),
                                    width: 25.0,
                                    style: BorderStyle.solid,
                                  ),
                                  left: BorderSide(
                                    color: _linkedEvent!.getColor(),
                                    width: 25.0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: DelayedScrollingText(
                                      text: _linkedEvent!.title,
                                      style: Theme.of(context).textTheme.displayLarge,
                                      delayDuration: Duration(seconds: 5),
                                    ),
                                  ))),
                        ),
                      ),
                    ),
                  ),
                )
                    :
                Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
