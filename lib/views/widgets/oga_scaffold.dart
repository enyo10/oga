import 'package:flutter/material.dart';
import 'package:oga/helper/oga_colors.dart';

class OgaScaffold extends StatelessWidget {
  const OgaScaffold(
      {super.key,
      required this.body,
      this.appBar,
      this.floatingActionButton,
      required this.resizeToAvoidBottomInset});
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
         colors: [OgaColors.appbar, OgaColors.notificationButtonBorderColor],

         // colors: [Color.fromRGBO(2, 29, 112, 1),Color.fromRGBO(9, 16, 44, 1), ],
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        backgroundColor: Colors.transparent,
        body: body,
      ),
    );
    /* return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(2, 29, 112, 1),
                  Color.fromRGBO(9, 16, 44, 1)
                ],
              ),
            ),
           // child: body,
          ),
         body,

        ],
      ),
    );*/
  }
}
