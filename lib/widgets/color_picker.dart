import 'package:flutter/material.dart';

import '../../helper/helper.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key, required this.colorData});
  final dynamic colorData;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  dynamic _selectedColorData = colorMap.entries.first;

  @override
  void initState() {
    _selectedColorData = widget.colorData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: colorMap.length - 1,
          itemBuilder: (BuildContext context, int index) {
            var colorData = colorMap.entries.elementAt(index);

            return ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Icon(
                colorData == _selectedColorData
                    ? Icons.lens
                    : Icons.trip_origin,
                color: colorData.value,
              ),
              title: Text(colorData.key),
              onTap: () {
                setState(() {
                  _selectedColorData = colorData;
                });
                Navigator.pop(context, _selectedColorData);
                // ignore: always_specify_types
                /*Future.delayed(const Duration(milliseconds: 200), ()  {
                  // When task is over, close the dialog
                 Navigator.pop(context, _selectedColorData);
                });*/
              },
            );
          },
        ),
      ),
    );
  }
}
