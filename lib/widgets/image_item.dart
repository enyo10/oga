import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ImageItem extends StatelessWidget {
  final File file;
  final int? index;
  final Color? color;
  final bool showImage;
  final VoidCallback onDeleteItem;

  const ImageItem({
    super.key,
    required this.file,
    this.index,
    required this.onDeleteItem,
    this.showImage = false,
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
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: showImage
                  ? Image.file(file)
                  : AutoSizeText(
                      basename(file.path),
                      overflow: TextOverflow.clip,
                    ),
            ),
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
