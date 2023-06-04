import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

class MyIntroduction extends Introduction {
  final String imageUrl;
  final double? imageWidth;
  final double? imageHeight;

  MyIntroduction({
    required this.imageUrl,
    this.imageWidth = 360,
    this.imageHeight = 360,
  }) : super(imageUrl: imageUrl, title: '', subTitle: '');

  @override
  State<StatefulWidget> createState() {
    return new MyIntroductionState();
  }
}

class MyIntroductionState extends State<MyIntroduction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Image(
                image: AssetImage(widget.imageUrl),
              ),
            )
        ],
      ),
    );
  }
}
