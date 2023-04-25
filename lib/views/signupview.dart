import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/professor.dart';
import 'package:mycsf_app_client/api/student.dart';
import 'package:mycsf_app_client/api/user.dart';
import 'package:mycsf_app_client/api/userrole.dart';

// class SignUpView extends StatelessWidget {
//   const SignUpView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("Signup")
//     );
//   }
// }

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  UserRole _role = UserRole.student;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = Student();
  }

  Widget _createFormField(String hintText, String errMsg, {required onSaved}) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, bottom: 12),
      child: SizedBox(
        height: 70,
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[900]),
            hintText: hintText,
            fillColor: Color(0xFFEDEDED),
            contentPadding: const EdgeInsets.only(
                left: 14.0, bottom: 6.0, top: 8.0
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEDEDED)),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEDEDED)),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          style: Theme.of(context).textTheme.displaySmall,
          // obscureText: true,
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
                child: Text(
                    "Регистрация",
                    style: Theme.of(context).textTheme.titleLarge
                ),
              ),
              _createFormField(
                "Имя пользователя",
                "Введите имя пользователя",
                onSaved: (value) {
                  _user.username = value;
                },
              ),
              _createFormField(
                "Фамилия",
                "Введите фамилию",
                onSaved: (value) {
                  _user.second_name = value;
                },
              ),
              _createFormField(
                "Имя",
                "Введите имя",
                onSaved: (value) {
                  _user.first_name = value;
                },
              ),
              _createFormField(
                "Отчество",
                "Введите отчество",
                onSaved: (value) {
                  _user.patronymic = value;
                },
              ),
              _createFormField(
                "Email",
                "Введите Email",
                onSaved: (value) {
                  _user.email = value;
                },
              ),
              _createFormField(
                "Телефон",
                "Введите телефон",
                onSaved: (value) {
                  _user.phone = value;
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 45, right: 45, bottom: 12),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Radio(
                          value: UserRole.student,
                          groupValue: _role,
                          onChanged: (value) {
                            setState(() {
                              _role = UserRole.student;
                              _user = Student();
                            });
                          },
                        ),
                        Text(
                            'Студент',
                            style: Theme.of(context).textTheme.displaySmall
                        ),
                        Radio(
                          value: UserRole.teacher,
                          groupValue: _role,
                          onChanged: (value) {
                            setState(() {
                              _role = UserRole.teacher;
                              _user = Professor();
                            });
                          },
                        ),
                        Text(
                            'Преподаватель',
                            style: Theme.of(context).textTheme.displaySmall
                        ),
                        Spacer()
                      ],
                    ),
                  )
              ),
              ElevatedButton(
                child: Text('Зарегистрироваться'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print(_user.email);
                  }
                },
              )
              // Padding(
              //   padding: EdgeInsets.only(left: 45.0, right: 54.0, top: 12),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       filled: true,
              //       hintStyle: TextStyle(color: Colors.grey[900]),
              //       hintText: "Пароль",
              //       fillColor: Color(0xFFEDEDED),
              //       contentPadding: const EdgeInsets.only(
              //           left: 14.0, bottom: 6.0, top: 8.0
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFFEDEDED)),
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFFEDEDED)),
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //     ),
              //     obscureText: true,
              //     validator: (val) {
              //       if (val == null || val.isEmpty) {
              //         return 'Введите пароль';
              //       }
              //       return null;
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
