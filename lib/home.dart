import 'package:flutter/material.dart';
import 'package:mycsf_app_client/appbar.dart';
import 'package:mycsf_app_client/drawer.dart';
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
    const NullView(),
    const NullView(),
    const NullView(),
    const NullView(),
    const NullView(),
    const NullView(),
    const NullView(),
    const NullView(),
    const NullView(),
  ];

  Function setNewViewIdx(int index) {
    return () {
      setState(() {
        _selectedViewIdx = index;
      });
      Navigator.pop(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedView = _selectedViewIdx != -1 ?
      _screens[_selectedViewIdx] :
      const HomeView();

    return Scaffold(
      drawer: NavDrawer(onTileTap: setNewViewIdx),
      appBar: createAppBar(context),
      body: selectedView,
    );
  }
}
