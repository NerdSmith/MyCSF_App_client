import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/chat/usercommon.dart';
import 'package:mycsf_app_client/views/chatview.dart';

class ChatListView extends StatefulWidget {
  final Function redirectToLogin;

  const ChatListView({Key? key, required this.redirectToLogin})
      : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  int? selfId;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<ChatUser> _searchedUsers = [];
  List<ChatRoom> _chatRooms = [];

  @override
  void initState() {
    super.initState();
    Auth.getCurrentRole().then((value) {
      if (value == Role.unauthorized) {
        widget.redirectToLogin();
      } else {
        UserCommonController.getSelfId().then((value) {
          print("got selfid: $value");
          setState(() {
            selfId = value;
          });
        }).catchError((err) {
          print(err);
        });
        _fetchChatRoomsWr();
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  _fetchChatRoomsWr() {
    UserCommonController.getChatRooms().then((value) {
      setState(() {
        _chatRooms = value;
      });
    });
  }

  _searchUsersFunc(String text) {
    UserCommonController.getUsersBySearch(text).then((value) {
      setState(() {
        _searchedUsers = value;
      });
    });
  }

  _openChat(ChatUser u) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatView(targetUser: u),
      ),
    );
  }

  _renderUser(ChatUser u) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: GestureDetector(
          onTap: () {
            _openChat(u);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    if (u.avatar != null)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(u.avatar!),
                            backgroundColor: Colors.transparent,
                            child: u.avatar != null
                                ? null
                                : CircularProgressIndicator(),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    Expanded(
                        child: Text(
                      u.fio(),
                      style: Theme.of(context).textTheme.displayMedium,
                      softWrap: true,
                    ))
                  ],
                ),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                    child: TextField(
                  style: Theme.of(context).textTheme.displayMedium,
                  textCapitalization: TextCapitalization.words,
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  onEditingComplete: () {
                    _focusNode.unfocus();
                    if (_textEditingController.text.isNotEmpty) {
                      _searchUsersFunc(_textEditingController.text);
                    } else {
                      setState(() {
                        _searchedUsers.clear();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Введите ФИО или никнейм...",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: Colors.grey[700]),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                )),
              ),
            ),
            AnimatedCrossFade(
                firstChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [for (var u in _searchedUsers) _renderUser(u)],
                  ),
                ),
                secondChild: Container(),
                crossFadeState: _searchedUsers.isNotEmpty
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0))),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20),
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              children: [
                for (var chatRoom in _chatRooms) _buildChatRoom(chatRoom)
              ],
            ),
          )),
        )
      ],
    );
  }

  Widget _buildChatRoom(ChatRoom cr) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          _openChat(ChatUser(
              cr.userId,
              cr.username,
              cr.first_name!,
              cr.second_name!,
              cr.patronymic!,
              cr.avatar
          ));
        },
        child: Container(
            decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  cr.avatar != null && cr.avatar!.isNotEmpty ?
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(cr.avatar!),
                        backgroundColor: Colors.transparent,
                        child: cr.avatar != null
                            ? null
                            : CircularProgressIndicator(),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ) :
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${cr.second_name} ${cr.first_name} ${cr.patronymic} @${cr.username}",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10), child: Text(
                        "${cr.userId == selfId ? 'Вы: ': ' '}${cr.lastMessage}",
                      ),)
                    ],
                  )
                ],
              ),
            )),
      )
    );
  }
}
