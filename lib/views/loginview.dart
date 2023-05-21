import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/dto/logindao.dart';
import 'package:mycsf_app_client/api/jwt.dart';

class LoginView extends StatefulWidget {
  Function onSuccess;

  LoginView({Key? key, required this.onSuccess}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late LoginDao loginDao;

  @override
  void initState() {
    super.initState();
    setState(() {
      loginDao = LoginDao();
    });
  }

  Widget _createFormField(String hintText, String errMsg,
      {required onSaved, bool isSecret = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, bottom: 6),
      child: SizedBox(
        height: 70,
        child: TextFormField(
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Text("Вход",
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge),
                      ),
                      _createFormField(
                        "Имя пользователя",
                        "Введите имя пользователя",
                        onSaved: (value) {
                          setState(() {
                            loginDao.username = value;
                          });
                        },
                      ),
                      _createFormField("Пароль", "Введите пароль",
                          onSaved: (value) {
                            setState(() {
                              loginDao.password = value;
                            });
                          },
                          isSecret: true),
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
                              elevation: 5,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Jwt.login(loginDao.username!, loginDao.password!).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Вход выполнен'),
                                    ),
                                  );
                                  Future.delayed(const Duration(seconds: 1));
                                  widget.onSuccess();
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ошибка входа: $error'),
                                    ),
                                  );
                                });
                              }
                            },
                            child: Text('Войти',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displayMedium),
                          ),
                        ),
                      )
                    ]))));
  }
}
