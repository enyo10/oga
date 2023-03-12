import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/helper/oga_colors.dart';

class OgaScaffold extends StatelessWidget {
  const OgaScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // colors: [OgaColors.appbar, OgaColors.notificationButtonBorderColor],
          // Color(0xFF0D47A1)
          // Color(0xFF90CAF9), Color(0xFFBBDEFB),Color(0xEEE1F5FE)
          colors: [Color(0xEEE1F5FE), Color(0xEEE1F5FE)],
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
