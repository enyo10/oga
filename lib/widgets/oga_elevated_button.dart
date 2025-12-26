import 'package:flutter/material.dart';
import 'package:oga/helper/oga_colors.dart';

class OgaElevatedButton extends StatelessWidget {
  const OgaElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [
      Colors.blue,
      Colors.indigo,
    ]),
  });

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [OgaColors.bleu3, OgaColors.blue1]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Container(
            // width: 300,
            height: 50,
            alignment: Alignment.center,
            child: const Text(
              'Ajouter',
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ),
    );
  }
}
