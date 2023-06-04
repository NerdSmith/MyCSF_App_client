import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:mycsf_app_client/backappbar.dart';
import 'package:mycsf_app_client/chat/noticontroller.dart';

import '../chat/usercommon.dart';

class ChatView extends StatefulWidget {
  final ChatUser targetUser;
  const ChatView({Key? key, required this.targetUser}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  NotificationController notiController = NotificationController();
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _currentText = "";
  List<ChatMessage> _messages = [];

  messageListener(ChatMessage msg) {
    setState(() {
      _messages.add(msg);
    });
    _postMsgEv();
  }

  _postMsgEv() async {
    Future.delayed(Duration(seconds: 2));
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Chat Page opened');
    notiController.setToRun(messageListener);
    UserCommonController.getChatMessages(widget.targetUser.id).then((value) {
      setState(() {
        _messages = value;
      });
    }).then((value) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        _scrollToBottom();
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    notiController.unsetToRun();
    super.dispose();
  }

  Future _scrollToBottom() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Future _addMessage(String content, bool isUser) async {
  //   GPTMessage msg = GPTMessage(content: content, isUser: isUser);
  //   setState(() {
  //     _messages.add(msg);
  //   });
  //   _scrollToBottom().then((value) {
  //     // GPTMessage m = GPTMessage(content: msg.content, isUser: false);
  //     // setState(() {
  //     //   _messages.add(m);
  //     // });
  //     GPTController.getAnswer(msg).then((value) {
  //       setState(() {
  //         _messages.add(value);
  //       });
  //     }).catchError((err) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Ошибка: $err'),
  //         ),
  //       );
  //     }).then((value) {
  //       Future.delayed(Duration(milliseconds: 400)).then((value) {
  //         _scrollToBottom();
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
            EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.targetUser.avatar != null && widget.targetUser.avatar!.isNotEmpty ?
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.targetUser.avatar!),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ) : Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(width: 20,),
                Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          widget.targetUser.fio(),
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
                  ChatMessage msg = _messages[index];
                  return Align(
                    alignment: msg.fromMessageUser != "${widget.targetUser.id}" ? Alignment.centerRight : Alignment.centerLeft,
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
                          msg.messageContent,
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
                        var messageObject = {
                          'message': promtText,
                          'to_user': widget.targetUser.id,
                        };
                        notiController.sendMessage(
                            messageObject, messageListener);
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
    );
  }
}
