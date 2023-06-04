import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/user.dart';

class NavDrawer extends StatefulWidget {
  Function onTileTap;
  User? user;
  Role? currentRole;

  NavDrawer({
    Key? key,
    required this.onTileTap,
    required this.user,
    required this.currentRole
  }) : super(key: key);

  static final itemText = [
    "Вход",
    "Регистрация",
    "Профиль",
    "Moodle",
    "BRS",
    "Карта",
    "Расписание",
    "Календарь",
    "Ассистент",
    "Чаты",
    "Настройки"
  ];

  static final itemIcon = [
    Image.asset("assets/menu_items/LogIn.png", height: 30),
    Image.asset("assets/menu_items/Signup.png", height: 30),
    Image.asset("assets/menu_items/Profile.png", height: 30),
    Image.asset("assets/menu_items/Moodle.png", height: 30),
    Image.asset("assets/menu_items/BRS.png", height: 30),
    Image.asset("assets/menu_items/Map.png", height: 30),
    Image.asset("assets/menu_items/Schedule.png", height: 30),
    Image.asset("assets/menu_items/Calendar.png", height: 30),
    Image.asset("assets/menu_items/AI.png", height: 30),
    Image.asset("assets/menu_items/Chat.png", height: 30),
    Image.asset("assets/menu_items/Settings.png", height: 30),
  ];

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

  @override
  void initState() {
    super.initState();
    // Auth.getCurrentRole().then((value) {
    //   setState(() {
    //     _currentRole = value;
    //   });
    //   if (value != Role.unauthorized) {
    //     Auth.getUserInfo().then((value) {
    //       setState(() {
    //         if (_user != value) {
    //           _user = value;
    //         }
    //       });
    //     });
    //   }
    // });
  }

  CircleAvatar getAvatar() {
    if (widget.user != null && widget.user!.avatar != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(widget.user!.avatar!  + '?random=' + DateTime.now().millisecondsSinceEpoch.toString()),
        backgroundColor: Colors.transparent,
        child: widget.user!.avatar != null ? null : CircularProgressIndicator(),
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage('assets/user_avatar_small.png'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.currentRole == Role.unauthorized)
                SizedBox(
                  height: 200,
                  child: DrawerHeader(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(),
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: DrawerHeader(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          getAvatar(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  Auth.getFullName(widget.user?.second_name,
                                      widget.user?.first_name, widget.user?.patronymic),
                                  style:
                                      Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                Auth.getRoleStr(widget.currentRole),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              Expanded(
                  child: Container(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                        itemCount: NavDrawer.itemText.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          // cond when unauthorized
                          if (widget.currentRole == Role.unauthorized && index == 2) {
                            return SizedBox.shrink();
                          }
                          if (widget.currentRole != Role.unauthorized &&
                              (index == 0 || index == 1)) {
                            return SizedBox.shrink();
                          }
                          return AppDrawerTile(
                            index: index,
                            onTap: widget.onTileTap,
                          );
                        }),
                  )),
              Container(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      const Divider(),
                      AppDrawerTile(
                        index: 10,
                        onTap: widget.onTileTap,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class AppDrawerTile extends StatelessWidget {
  const AppDrawerTile({Key? key, required this.index, required this.onTap})
      : super(key: key);

  final int index;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 40,
        child: ListTile(

            leading: SizedBox(width: 60, child: NavDrawer.itemIcon[index]),
            title: Text(
              NavDrawer.itemText[index],
              style: Theme.of(context).textTheme.displayLarge,
            ),
            onTap: onTap(index)),
      )
    );
  }
}
