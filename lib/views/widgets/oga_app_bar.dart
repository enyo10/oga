import 'package:flutter/material.dart';

class OgaAppBar extends StatelessWidget {
  const OgaAppBar({Key? key, this.title}) : super(key: key);
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
    );
  }
}
