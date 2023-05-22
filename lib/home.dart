import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/avatar.dart';
import 'package:mycsf_app_client/appbar.dart';
import 'package:mycsf_app_client/drawer.dart';
import 'package:mycsf_app_client/drawerbottom.dart';
import 'package:mycsf_app_client/views/brsview.dart';
import 'package:mycsf_app_client/views/homeview.dart';
import 'package:mycsf_app_client/views/loginview.dart';
import 'package:mycsf_app_client/views/mapview.dart';
import 'package:mycsf_app_client/views/moodleview.dart';
import 'package:mycsf_app_client/views/nullview.dart';
import 'package:mycsf_app_client/views/profileview.dart';
import 'package:mycsf_app_client/views/settingsview.dart';
import 'package:mycsf_app_client/views/signupview.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedViewIdx = -1;
  String? _avatarUrl;

  Function setNewViewIdx(int index) {
    return () {
      AvatarService.fetchAvatar().then((value) {
        if (_avatarUrl != value) {
          setState(() {
            _avatarUrl = value;
          });
        }
      });
      setState(() {
        _selectedViewIdx = index;
      });
      Navigator.pop(context);
    };
  }

  void setNewViewIdx4Bottom(int index) {
    AvatarService.fetchAvatar().then((value) {
      if (_avatarUrl != value) {
        setState(() {
          _avatarUrl = value;
        });
      }
    });
    setState(() {
      _selectedViewIdx = index;
    });
  }

  List<Widget> _screens = [];
  final home = const HomeView();

  @override
  void initState() {
    super.initState();
    Auth.performAuthCheck();
    setState(() {
      _screens = [
        LoginView(onSuccess: () {
          setNewViewIdx4Bottom(-1);
        }), // 0
        SignUpView(onSuccess: () {
          setNewViewIdx4Bottom(-1);
        }), // 1
        ProfileView(), // 2
        MoodleView(redirectToLogin: () {
          setNewViewIdx4Bottom(0);
        }), // 3
        BrsView(redirectToLogin: () {
          setNewViewIdx4Bottom(0);
        }), // 4
        MapView(), // 5
        const NullView("Schedule"), // 6
        const NullView("Calendar"), // 7
        const NullView("AI"), // 8
        const NullView("Chat"), // 9
        SettingsView(
          setHome: () {
            setNewViewIdx4Bottom(-1);
          },
        ) // 10
      ];
    });
    AvatarService.fetchAvatar().then((value) {
      if (_avatarUrl != value) {
        setState(() {
          _avatarUrl = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedView = (_selectedViewIdx != -1) ?
      _screens[_selectedViewIdx] :
      home;

    return Scaffold(
      drawer: NavDrawer(onTileTap: setNewViewIdx),
      bottomNavigationBar: NavDrawerBottom(
          onTileTap: setNewViewIdx4Bottom,
          selectedIdx: _selectedViewIdx
      ),
      appBar: MyAppBar(avatarUrl: _avatarUrl),
      body: selectedView,
    );
  }
}
