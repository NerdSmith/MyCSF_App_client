import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/avatar.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? avatarUrl;

  MyAppBar({Key? key, required this.avatarUrl}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(50);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) {
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu,
                size: 30,
              ));
        },
      ),
      title: Image.asset(
        'assets/my_csf_logo.png',
        height: 30,
      ),
      actions: [
        widget.avatarUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(widget.avatarUrl!  + '?random=' + DateTime.now().millisecondsSinceEpoch.toString()),
                backgroundColor: Colors.transparent,
                // Set the background color to transparent
                child: widget.avatarUrl != null
                    ? null
                    : CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                      ),
              )
            : const CircleAvatar(
                backgroundColor: Colors.transparent,
              )
      ],
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          )),
    );
  }
}
