import 'package:flutter/material.dart';

class ImageWithTopShadowWidget extends StatelessWidget {
  final String imagePath;

  const ImageWithTopShadowWidget(this.imagePath, {required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}
