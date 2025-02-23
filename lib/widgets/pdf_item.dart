import 'dart:io';
import 'package:flutter/material.dart';

class PdfItem extends StatelessWidget {
  const PdfItem(
      {Key? key,
      required this.file,
      this.index,
      this.color,
      required this.onDeleteItem})
      : super(key: key);
  final File file;
  final int? index;
  final Color? color;
  final VoidCallback onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
