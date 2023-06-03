import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/avatar.dart';
import 'package:mycsf_app_client/appbar.dart';
import 'package:mycsf_app_client/drawer.dart';
import 'package:mycsf_app_client/drawerbottom.dart';
import 'package:mycsf_app_client/views/brsview.dart';
import 'package:mycsf_app_client/views/calendarview.dart';
import 'package:mycsf_app_client/views/homeview.dart';
import 'package:mycsf_app_client/views/loginview.dart';
import 'package:mycsf_app_client/views/mapview.dart';
import 'package:mycsf_app_client/views/moodleview.dart';
import 'package:mycsf_app_client/views/nullview.dart';
import 'package:mycsf_app_client/views/profileview.dart';
import 'package:mycsf_app_client/views/publicationsview.dart';
import 'package:mycsf_app_client/views/scheduleview.dart';
import 'package:mycsf_app_client/views/settingsview.dart';
import 'package:mycsf_app_client/views/signupview.dart';

import 'api/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedViewIdx = -1;
  User? _user;
  Role? _currentRole;

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

  var _screens = [];
  home() {
    return PublicationsView(
      redirectToCalendar: () {
        setNewViewIdx4Bottom(7);
      },
    ); // idx = -1
  }

  @override
  void initState() {
    super.initState();
    Auth.performAuthCheck();
    setState(() {
      _screens = [
        () => LoginView(
            onSuccess: () {
              setNewViewIdx4Bottom(-1);
            },
            forceUpdateUser: () {
              userUpdate();
            }
            ), // 0
        () => SignUpView(onSuccess: () {
              setNewViewIdx4Bottom(-1);
            },
            forceUpdateUser: () {
              userUpdate();
            }
        ), // 1
        () => ProfileView(forceUpdateUser: () {
          userUpdate();
        }), // 2
        () => MoodleView(redirectToLogin: () {
              setNewViewIdx4Bottom(0);
            }), // 3
        () => BrsView(redirectToLogin: () {
              setNewViewIdx4Bottom(0);
            }), // 4
        () => MapView(), // 5
        () => ScheduleView(redirectToLogin: () {
          setNewViewIdx4Bottom(0);
        }), // 6
        () => MyCalendarView(redirectToLogin: () {
          setNewViewIdx4Bottom(0);
        }), // 7
        () => NullView("AI"), // 8
        () => NullView("Chat"), // 9
        () => SettingsView(
              forceUpdateUser: () {
                userUpdate();
              },
              setHome: () {
                setNewViewIdx4Bottom(-1);
              },
            ) // 10
      ];
    });
    userUpdate();
  }

  userUpdate() {
    Auth.getCurrentRole().then((value) {
      setState(() {
        _currentRole = value;
      });
      if (value != Role.unauthorized) {
        Auth.getUserInfo().then((value) {
          setState(() {
            if (_user != value) {
              _user = value;
            }
          });
        });
      }
      else {
        _user = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic selectedView;
    switch (_selectedViewIdx) {
      case -1:
        selectedView = home;
        break;
      default:
        selectedView = _screens[_selectedViewIdx];
        break;
    }

    return Scaffold(
      drawer: NavDrawer(
        onTileTap: setNewViewIdx,
        user: _user,
        currentRole: _currentRole,
      ),
      bottomNavigationBar: NavDrawerBottom(
          onTileTap: setNewViewIdx4Bottom, selectedIdx: _selectedViewIdx),
      appBar: MyAppBar(avatarUrl: _user?.avatar),
      body: selectedView(),
    );
  }
}
