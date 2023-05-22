import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:mycsf_app_client/webview_services/brsclaims.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrsView extends StatefulWidget {
  Function redirectToLogin;
  String url = "https://www.cs.vsu.ru/brs/login";

  BrsView({Key? key, required this.redirectToLogin}) : super(key: key);

  @override
  State<BrsView> createState() => _BrsViewState();
}

class _BrsViewState extends State<BrsView> {
  WebViewController? _controller;

  void _fillFormFields() {
    if (_controller != null) {
      Auth.getCurrentRole().then((value) {
        if (value != Role.unauthorized) {
          BrsClaims().getLogPassClaims().then((value) {
            if (value != null) {
              _controller!.runJavascript('''
          if (document.getElementById('login') != null) {
            document.getElementById('login').value = '${value.login}';
            document.getElementById('password').value = '${value.password}';
            var button = document.getElementById('button_login');
            button.click();
          }
          ''');
            }
          });
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
