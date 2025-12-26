import 'dart:ui';

import 'package:flutter/material.dart';

class OgaGlassContainer extends StatelessWidget {
  const OgaGlassContainer(
      {super.key, required this.child, this.onTap, this.width, this.height});
  final Widget child;
  final void Function()? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
             height: height ?? size.height * 0.20,
              width: width ?? size.width * 0.96,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Stack(
                children: [
                  //Blur Effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(),
                  ),
                  //Gradient Effect
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.20)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ]),
                    ),
                  ),
                  child,
                  // OgaListTile(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
