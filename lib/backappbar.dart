import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/avatar.dart';

class BackAppBar extends StatefulWidget implements PreferredSizeWidget {

  const BackAppBar({Key? key}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(50);

  @override
  State<BackAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends State<BackAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Image.asset(
        'assets/my_csf_logo.png',
        height: 30,
      ),
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
