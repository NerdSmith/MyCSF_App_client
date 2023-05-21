
import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrsView extends StatefulWidget {
  Function redirectToLogin;
  String url = "https://www.cs.vsu.ru/brs/login";

  BrsView({Key? key, required this.redirectToLogin}) : super(key: key);

  @override
  State<BrsView> createState() => _BrsViewState();
}

class _BrsViewState extends State<BrsView> {

  @override
  void initState() {
    super.initState();
    Auth.getCurrentRole().then((value) {
      if (value == Role.unauthorized) {
        widget.redirectToLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
