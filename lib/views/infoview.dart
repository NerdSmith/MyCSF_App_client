import 'package:flutter/material.dart';
import 'package:mycsf_app_client/backappbar.dart';

class InfoView extends StatelessWidget {
  const InfoView({Key? key}) : super(key: key);


  Widget _makeTitle(String title, TextStyle? style) {
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
                            style: style,
                          ),
                        )))))
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              children: [
                Image.asset("assets/logo.png"),
                _makeTitle("Мой ФКН", Theme.of(context).textTheme.displaySmall),
                _makeTitle("Версия 0.9.5", Theme.of(context).textTheme.displaySmall),
                _makeTitle("Сборка 04.06.2023", Theme.of(context).textTheme.displaySmall),
                _makeTitle("Приложение - ассистент", Theme.of(context).textTheme.displaySmall)
              ],
            ),
          ),
        ),
      )
    );
  }
}
