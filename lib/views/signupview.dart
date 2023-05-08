import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/coursegroup.dart';
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
  final TextEditingController _typeAheadController = TextEditingController();
  List<CourseGroup> _courseGroup = [];
  CourseGroup? _selectedSuggestion;

  @override
  void initState() {
    super.initState();
    _user = Student();
    CourseGroup.fetchAll().then((data) => setState(() {
      _courseGroup = data;
    }));
  }

  Widget _createFormField(
      String hintText,
      String errMsg,
      {
        required onSaved,
        bool isSecret = false
      }
      ) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, bottom: 6),
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
                "Пароль",
                "Введите пароль",
                onSaved: (value) {
                  _user.password = value;
                },
                isSecret: true
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
                  padding: const EdgeInsets.only(left: 45, right: 45, bottom: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEDEDED),
                      // borderSide: BorderSide(color: Color(0xFFEDEDED)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SizedBox(
                      height: 45,
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
                    ),
                  )
              ),
              if (_role == UserRole.student)
                Column(
                  children: [
                    _createFormField(
                      "Год зачисления",
                      "Введите год зачисления",
                      onSaved: (value) {
                        (_user as Student).year_of_enrollment = value;
                      },
                    ),
                    _createFormField(
                      "Номер зачетной книжки",
                      "Введите номер зачетной книжки",
                      onSaved: (value) {
                        (_user as Student).record_book_number = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 45, right: 45, bottom: 6),
                      child: SizedBox(
                        height: 70,
                        child: TypeAheadFormField(
                          validator: (val) {
                            if (
                              val == null ||
                              val.isEmpty ||
                              _selectedSuggestion == null
                            ) {
                              return "Выберите данные из списка";
                            }
                            return null;
                          },
                          direction: AxisDirection.up,
                          textFieldConfiguration: TextFieldConfiguration(
                              onChanged: (value) {
                                _selectedSuggestion = null;
                              },
                              controller: _typeAheadController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[900]),
                              hintText: "Курс, группа, уровень образования",
                              fillColor: Color(0xFFEDEDED),
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 6.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFEDEDED)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFEDEDED)),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            style: Theme.of(context).textTheme.displaySmall
                          ),
                          // style: Theme.of(context).textTheme.displaySmall,
                          suggestionsCallback: (pattern) async {
                            return _courseGroup.where((item) =>
                                item.toString().toLowerCase().contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion.toString(),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              _selectedSuggestion = suggestion;
                            });
                            _typeAheadController.text = suggestion.toString();
                          },
                          noItemsFoundBuilder: (BuildContext context) {
                            return ListTile(
                              title: Text(
                                "Нет результатов",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            );
                          },
                          onSaved: (value) {
                            (_user as Student).course_group =
                                _selectedSuggestion!.id;
                          },
                        ),
                      ),
                    )

                  ],
                ),
              if (_role == UserRole.teacher)
                _createFormField(
                  "Кафедра",
                  "Введите название кафедры",
                  onSaved: (value) {
                    (_user as Professor).department = value;
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45, top: 10, bottom: 10),
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
                        switch (_role) {
                          case UserRole.teacher:
                            print(jsonEncode((_user as Professor).toJson()));
                            break;
                          case UserRole.student:
                            print(jsonEncode((_user as Student).toJson()));
                            break;
                        }
                      }
                    },
                    child: Text(
                        'Зарегистрироваться',
                        style: Theme.of(context).textTheme.displayMedium
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
