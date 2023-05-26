import 'package:flutter/material.dart';

class LoadingImageWidget extends StatefulWidget {
  final String imageUrl;

  const LoadingImageWidget({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  State<LoadingImageWidget> createState() => _LoadingImageWidgetState();
}

class _LoadingImageWidgetState extends State<LoadingImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(widget.imageUrl, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD9D9D9),
      ));
    });
  }
}
