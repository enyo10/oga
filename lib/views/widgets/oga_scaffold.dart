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
     return Scaffold(
       extendBodyBehindAppBar: true,
       appBar: appBar,
       floatingActionButton: floatingActionButton,
       body:  Stack(
       children: [
         Container(
           decoration: BoxDecoration(

             image: DecorationImage(
               image: AssetImage(backgroundImage ?? 'assets/oga_porte_v.jpg'),
               fit: BoxFit.fill,
             ),
           ),
           // child: body,
         ),
         body,
       ],
     ),
     );




    return Scaffold(
      appBar: appBar ??
          AppBar(
           // backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/oga_porte_v_app_bar.jpg'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              /*gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(2, 29, 112, 1),
                  Color.fromRGBO(9, 16, 44, 1)
                ],
              ),*/
              image: DecorationImage(
                image: AssetImage(backgroundImage ?? 'assets/oga_porte_v.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            // child: body,
          ),
          body,
        ],
      ),
    );
  }
}
