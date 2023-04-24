import 'package:flutter/material.dart';
import 'package:mycsf_app_client/appbar.dart';
import 'package:mycsf_app_client/drawer.dart';
import 'package:mycsf_app_client/drawerbottom.dart';
import 'package:mycsf_app_client/views/homeview.dart';
import 'package:mycsf_app_client/views/loginview.dart';
import 'package:mycsf_app_client/views/nullview.dart';
import 'package:mycsf_app_client/views/signupview.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedViewIdx = -1;
  final List<Widget> _screens = [
    const LoginView(),
    const SignUpView(),
    const NullView("Profile"),
    const NullView("Moodle"),
    const NullView("Brs"),
    const NullView("Map"),
    const NullView("Schedule"),
    const NullView("Calendar"),
    const NullView("AI"),
    const NullView("Chat"),
    const NullView("Settings"),
  ];
  final home = const HomeView();

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
