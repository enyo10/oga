import 'dart:io';
import 'package:flutter/material.dart';

class PdfItem extends StatelessWidget {
  const PdfItem(
      {super.key,
      required this.file,
      this.index,
      this.color,
      required this.onDeleteItem});
  final File file;
  final int? index;
  final Color? color;
  final VoidCallback onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
