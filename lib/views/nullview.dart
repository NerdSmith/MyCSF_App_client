import 'package:flutter/material.dart';

class NullView extends StatelessWidget {
  final text;
  const NullView(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
