import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mycsf_app_client/api/gptmessage.dart';

import '../api/auth.dart';

class ChatGPTView extends StatefulWidget {
  final Function redirectToLogin;
  const ChatGPTView({Key? key, required this.redirectToLogin}) : super(key: key);

  @override
  State<ChatGPTView> createState() => _ChatGPTViewState();
}

class _ChatGPTViewState extends State<ChatGPTView> {
  bool _render = false;
  String _currentText = "";
  List<GPTMessage> _messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Auth.getCurrentRole().then((value) {
      if (value == Role.unauthorized) {
        widget.redirectToLogin();
      } else {
        setState(() {
          _render = true;
        });
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _scrollToBottom() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future _addMessage(String content, bool isUser) async {
    GPTMessage msg = GPTMessage(content: content, isUser: isUser);
    setState(() {
      _messages.add(msg);
    });
    _scrollToBottom().then((value) {
      // GPTMessage m = GPTMessage(content: msg.content, isUser: false);
      // setState(() {
      //   _messages.add(m);
      // });
      GPTController.getAnswer(msg).then((value) {
        setState(() {
          _messages.add(value);
        });
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $err'),
          ),
        );
      }).then((value) {
        Future.delayed(Duration(milliseconds: 400)).then((value) {
          _scrollToBottom();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _render ? Stack(
      children: [
        Center(
          child: Image.asset("assets/brains.png"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/dartanyan.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "Самый умный студент ФКН",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0))),
              ),
            ),
            Expanded(

                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (_messages.length == index)
                      return Container(
                        height: 50,
                      );
                    GPTMessage msg = _messages[index];
                    return Align(
                      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            msg.content,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                    );
                  },
                )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                ),
                color: Color(0xFFD9D9D9),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      _currentText = value;
                    });
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: _currentText != "" ?
                    GestureDetector(
                      onTap: () {
                        String promtText = _currentText;
                        _controller.clear();
                        setState(() {
                          _currentText = "";
                        });
                        _addMessage(promtText, true);

                      },
                      child: Icon(Icons.arrow_forward, color: Colors.black,),
                    )
                        :
                    null,
                    hintText: 'Введите еще одну умную мысль...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              )
            )
          ],
        )
      ],
    ) : Container();
  }
}
