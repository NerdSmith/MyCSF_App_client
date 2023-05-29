import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/api/avatar.dart';

import '../api/user.dart';

class ProfileView extends StatefulWidget {

  Function forceUpdateUser;
  ProfileView({Key? key, required this.forceUpdateUser}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  String? _roleStr;
  User? _user;

  @override
  void initState() {
    super.initState();
    Auth.getUserInfo().then((value) {
      setState(() {
        _user = value;
      });
    });
    Auth.getRole().then((value) {
      setState(() {
        _roleStr = Auth.getRoleStr(value);
      });
    });
  }

  Widget _createFormField(String hintText, String errMsg, String value,
      {required onSaved, bool isSecret = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, bottom: 6),
      child: SizedBox(
        height: 70,
        child: TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[900]),
            hintText: hintText,
            fillColor: Color(0xFFEDEDED),
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

  @override
  Widget build(BuildContext context) {

    return Form(
        key: _formKey,
        child: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              GestureDetector(
                  onTap: () {
                    AvatarService.uploadAvatar().then((value) {
                      setState(() {
                        _user!.avatar = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Аватар изменен'),
                        ),
                      );
                    }).then((value) {
                      widget.forceUpdateUser();
                    }).catchError((err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Не удалось изменить аватар'),
                        ),
                      );
                    });
                  },
                  child: _user != null && _user!.avatar != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(_user!.avatar!),
                          backgroundColor: Colors.transparent,
                          child: _user!.avatar != null
                              ? null
                              : CircularProgressIndicator(),
                        )
                      : const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/user_avatar_small.png'),
                        )),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 45, right: 45, bottom: 25),
                          child: SizedBox(
                              height: 50,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEDEDED),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _roleStr != null ? _roleStr! : "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                  )))))
                ],
              ),
              if (_user != null)
              _createFormField(
                "Имя",
                "Введите имя",
                _user!.first_name!,
                onSaved: (value) {
                  _user!.first_name = value;
                },
              ),
              if (_user != null)
                _createFormField(
                  "Фамилия",
                  "Введите фамилию",
                  _user!.second_name!,
                  onSaved: (value) {
                    _user!.second_name = value;
                  },
                ),
              if (_user != null)
                _createFormField(
                  "Отчество",
                  "Введите отчество",
                  _user!.patronymic!,
                  onSaved: (value) {
                    _user!.patronymic = value;
                  },
                ),
              if (_user != null)
                _createFormField(
                  "Email",
                  "Введите Email",
                  _user!.email!,
                  onSaved: (value) {
                    _user!.email = value;
                  },
                ),
                if (_user != null)
                  _createFormField(
                    "Номер телефона",
                    "Введите номер телефона",
                    _user!.phone!,
                    onSaved: (value) {
                      _user!.phone = value;
                    },
                  ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45, right: 45, top: 10, bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEDEDED),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 10,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Auth.updateUserInfo(
                                  first_name: _user!.first_name!,
                                  second_name: _user!.second_name!,
                                  patronymic: _user!.patronymic!,
                                  phone: _user!.phone!,
                                  email: _user!.email!
                                ).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Данные изменены'),
                                    ),
                                  );
                                  widget.forceUpdateUser();
                                }).catchError((err) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ошибка создания: $err'),
                                    ),
                                  );
                                });
                              }
                            },
                            child: Text('Изменить',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displaySmall),
                          ),
                        ),
                      )
            ]))));

    //   SingleChildScrollView(
    //     child: Center(
    //         child: Padding(
    //             padding: const EdgeInsets.only(left: 45, right: 45, top: 15),
    //             child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   CircleAvatar(
    //                     radius: 60,
    //                     backgroundImage: NetworkImage(
    //                       'https://example.com/avatar.jpg', // Замените ссылкой на аватар пользователя
    //                     ),
    //                   ),
    //                 ]
    //             )
    //         )
    //     )
    // );
  }
}
