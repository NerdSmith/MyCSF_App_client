import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';

class SettingsView extends StatefulWidget {
  Function setHome;

  SettingsView({Key? key, required this.setHome}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isUnauthorized = false;

  @override
  void initState() {
    super.initState();
    Auth.isUnauthorized().then((value) => setState(() {
          _isUnauthorized = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 40, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!_isUnauthorized)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD9D9D9),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              minimumSize: Size(200, 50),
                              elevation: 1,
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              Auth.performLogout();
                              setState(() {
                                _isUnauthorized = true;
                              });
                            },
                            child: Text(
                              'Выйти из аккаунта',
                              style: Theme.of(context).textTheme.displaySmall,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )
                      ],
                    ),
                ],
              ))),
    );
  }
}
