import 'package:flutter/material.dart';

class OgaScaffold extends StatelessWidget {
  const OgaScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.backgroundImage,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage ?? 'assets/oga_porte_v.jpg'),
          fit: BoxFit.fill,
            alignment: Alignment.bottomCenter

        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,

          resizeToAvoidBottomInset: true,

          appBar: appBar,
          floatingActionButton: floatingActionButton,
          body: body),
    );
  }
}
