import 'package:flutter/material.dart';

AppBar createAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 50,
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
    actions: const <Widget>[
      CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('assets/user_avatar_small.png'),
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