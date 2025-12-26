import 'package:flutter/material.dart';

class ImageEnlargement extends StatefulWidget {
  const ImageEnlargement({super.key, required this.imageUrl});
  final String? imageUrl;

  @override
  State<ImageEnlargement> createState() => _ImageEnlargementState();
}

class _ImageEnlargementState extends State<ImageEnlargement> {
  @override
  Widget build(BuildContext context) {
    String url = widget.imageUrl!;
    var imageName = (url.split('?').first).split("%2F").last;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: imageName,
            child: Center(
              child: Image.network(widget.imageUrl!),
            ),
          ),
        ),
      ),
    );
  }
}
