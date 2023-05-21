import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/appbar.dart';
import 'package:mycsf_app_client/drawer.dart';
import 'package:mycsf_app_client/drawerbottom.dart';
import 'package:mycsf_app_client/views/homeview.dart';
import 'package:mycsf_app_client/views/loginview.dart';
import 'package:mycsf_app_client/views/nullview.dart';
import 'package:mycsf_app_client/views/settingsview.dart';
import 'package:mycsf_app_client/views/signupview.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedViewIdx = -1;

  Function setNewViewIdx(int index) {
    return () {
      setState(() {
        _selectedViewIdx = index;
      });
      Navigator.pop(context);
    };
  }

  void setNewViewIdx4Bottom(int index) {
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
        }),
        SignUpView(onSuccess: () {
          setNewViewIdx4Bottom(-1);
        }),
        const NullView("Profile"),
        const NullView("Moodle"),
        const NullView("Brs"),
        const NullView("Map"),
        const NullView("Schedule"),
        const NullView("Calendar"),
        const NullView("AI"),
        const NullView("Chat"),
        SettingsView(
          setHome: () {
            setNewViewIdx4Bottom(-1);
          },
        )
      ];
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
      appBar: createAppBar(context),
      body: selectedView,
    );
  }
}
