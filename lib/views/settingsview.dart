import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/views/contactsview.dart';
import 'package:mycsf_app_client/views/infoview.dart';
import 'package:mycsf_app_client/views/moodleview.dart';
import 'package:mycsf_app_client/webview_services/brsclaims.dart';
import 'package:mycsf_app_client/webview_services/logpassclaims.dart';
import 'package:mycsf_app_client/webview_services/moodleclaims.dart';

class SettingsView extends StatefulWidget {
  Function setHome;
  Function forceUpdateUser;

  SettingsView({Key? key, required this.setHome, required this.forceUpdateUser}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _brsFormKey = GlobalKey<FormState>();
  final _moodleFormKey = GlobalKey<FormState>();

  bool _isUnauthorized = false;

  bool _showBrsClaims = false;
  LogPassClaims _brsClaims = LogPassClaims();

  bool _showMoodleClaims = false;
  LogPassClaims _moodleClaims = LogPassClaims();

  @override
  void initState() {
    super.initState();
    Auth.isUnauthorized().then((value) {
      setState(() {
        _isUnauthorized = value;
      });
    });
    BrsClaims().getLogPassClaims().then((value) {
      if (value != null) {
        setState(() {
          _brsClaims = value;
        });
      }
    });
    MoodleClaims().getLogPassClaims().then((value) {
      if (value != null) {
        setState(() {
          _moodleClaims = value;
        });
      }
    });
  }

  Widget _createFormField(String hintText, String errMsg, String value,
      {required onSaved, bool isSecret = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 0, bottom: 6),
      child: SizedBox(
        height: 70,
        child: TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[900]),
            hintText: hintText,
            fillColor: Color(0xFFD9D9D9),
            contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEDEDED)),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEDEDED)),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          style: Theme
              .of(context)
              .textTheme
              .displaySmall,
          obscureText: isSecret,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return errMsg;
            }
            return null;
          },
          onSaved: onSaved,
        ),
      ),
    );
  }

  Widget _makeTitle(String title) {
    return Row(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 25),
                child: SizedBox(
                    height: 50,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        )))))
      ],
    );
  }

  Widget _makeButton({required String text, required Function f, double paddingLeft = 0, double paddingRight = 0}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: paddingLeft, right: paddingRight, bottom: 25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD9D9D9),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(200, 50),
              elevation: 10,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {
              f();
            },
            child: Text(
              text,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.left,
            ),
          ),
        ))
      ],
    );
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
                    Column(
                      children: [
                        _makeTitle("Данные для входа в BRS"),
                        if (_showBrsClaims)
                          Form(
                            key: _brsFormKey,
                            child: Column(
                              children: [
                                _createFormField(
                                    "Логин BRS",
                                    "Введите логин",
                                    _brsClaims.login != null ? _brsClaims.login! : "",
                                    onSaved: (value) {
                                      setState(() {
                                        _brsClaims.login = value;
                                      });
                                    },
                                ),
                                _createFormField(
                                  "Пароль BRS",
                                  "Введите пароль",
                                  _brsClaims.password != null ? _brsClaims.password! : "",
                                  onSaved: (value) {
                                    setState(() {
                                      _brsClaims.password = value;
                                    });
                                  },
                                  isSecret: true
                                )
                              ],
                            ),
                          ),
                        _makeButton(text: _showBrsClaims ? "Скрыть" : "Показать", f: () {
                          setState(() {
                            _showBrsClaims = !_showBrsClaims;
                          });
                        },
                        paddingLeft: 50),
                        if (_showBrsClaims)
                        _makeButton(text: "Сохранить", f: () {
                          if (_brsFormKey.currentState!.validate()) {
                            _brsFormKey.currentState!.save();

                            BrsClaims().saveLogPass(_brsClaims).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Сохранено'),
                                ),
                              );
                            }).catchError((err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ошибка'),
                                ),
                              );
                            });
                          }
                        },
                        paddingLeft: 50),
                        SizedBox(
                          height: 20,
                        ),
                        _makeTitle("Данные для входа в Moodle"),
                        if (_showMoodleClaims)
                          Form(
                            key: _moodleFormKey,
                            child: Column(
                              children: [
                                _createFormField(
                                  "Логин Moodle",
                                  "Введите логин",
                                  _moodleClaims.login != null ? _moodleClaims.login! : "",
                                  onSaved: (value) {
                                    setState(() {
                                      _moodleClaims.login = value;
                                    });
                                  },
                                ),
                                _createFormField(
                                    "Пароль Moodle",
                                    "Введите пароль",
                                    _moodleClaims.password != null ? _moodleClaims.password! : "",
                                    onSaved: (value) {
                                      setState(() {
                                        _moodleClaims.password = value;
                                      });
                                    },
                                    isSecret: true
                                )
                              ],
                            ),
                          ),
                        _makeButton(text: _showMoodleClaims ? "Скрыть" : "Показать", f: () {
                          setState(() {
                            _showMoodleClaims = !_showMoodleClaims;
                          });
                        },
                        paddingLeft: 50),
                        if (_showMoodleClaims)
                          _makeButton(text: "Сохранить", f: () {
                            if (_moodleFormKey.currentState!.validate()) {
                              _moodleFormKey.currentState!.save();

                              MoodleClaims().saveLogPass(_moodleClaims).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Сохранено'),
                                  ),
                                );
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ошибка'),
                                  ),
                                );
                              });
                            }
                          },
                          paddingLeft: 50),
                        SizedBox(
                          height: 20,
                        ),
                        _makeButton(
                            text: 'О приложении',
                            f: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoView(),
                                ),
                              );
                            }
                        ),
                        _makeButton(
                            text: 'Контакты',
                            f: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactsView(),
                                ),
                              );
                            }
                        ),
                        _makeButton(
                          text: 'Выйти из аккаунта',
                          f: () {
                            Auth.performLogout();
                            setState(() {
                              _isUnauthorized = true;
                            });
                            widget.forceUpdateUser();
                          }
                        ),
                      ],
                    )
                ],
              ))),
    );
  }
}
