import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/webview_services/brsclaims.dart';
import 'package:mycsf_app_client/webview_services/moodleclaims.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoodleView extends StatefulWidget {
  Function redirectToLogin;
  String url = "https://edu.vsu.ru/login/index.php";

  MoodleView({Key? key, required this.redirectToLogin}) : super(key: key);

  @override
  State<MoodleView> createState() => _MoodleViewState();
}

class _MoodleViewState extends State<MoodleView> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    Auth.getCurrentRole().then((value) {
      if (value == Role.unauthorized) {
        widget.redirectToLogin();
      }
    });
  }

  void _fillFormFields() {
    if (_controller != null) {
      MoodleClaims().getLogPassClaims().then((value) {
        if (value != null) {
          _controller!.runJavascript('''
          if (document.getElementById('username') != null) {
            document.getElementById('username').value = '${value.login}';
            document.getElementById('password').value = '${value.password}';
            var button = document.getElementById('loginbtn');
            button.click();
          }
          else {
            var secondaryBtns = document.getElementsByClassName('btn-secondary');
            if (secondaryBtns[0] && secondaryBtns[0].innerText == "Отмена") {
              secondaryBtns[0].click();
            }
          }
          ''');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _controller = controller;
      },
      onPageFinished: (url) {
        _fillFormFields();
      },
    );
  }

}
