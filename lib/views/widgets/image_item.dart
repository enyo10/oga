import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final File file;
  final int? index;
  final Color? color;
  final VoidCallback onDeleteItem;

  const ImageItem({
    super.key,
    required this.file,
    this.index,
    required this.onDeleteItem,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      // margin: EdgeInsets.fromLTRB(100, 10, 100, 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.file(
            file,
            width: 100,
            height: 100,
            fit: BoxFit.fitHeight,
          ),
          InkWell(
            onDoubleTap: onDeleteItem,
            child: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}
