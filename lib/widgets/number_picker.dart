import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class PickedNumber extends StatefulWidget {
  const PickedNumber( {super.key, required this.currentValue, required this.minValue});
  final int currentValue;
  final int minValue;

  @override
  State<PickedNumber> createState() => _PickedNumberState();
}

class _PickedNumberState extends State<PickedNumber> {
  late int _currentIntValue;
  late int _minValue;
  @override
  void initState() {
    _currentIntValue = widget.currentValue;
    _minValue = widget.minValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_currentIntValue);
            },
            child: const Text("OK"),
          )
        ]),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child:
                  Text('Année', style: Theme.of(context).textTheme.bodyLarge),
            ),
            NumberPicker(
              value: _currentIntValue,
              minValue: _minValue,
              maxValue: 2040,
              step: 1,
              haptics: true,
              onChanged: (value) => setState(() {
                _currentIntValue = value;
              }),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = _currentIntValue - 1;
                    _currentIntValue = newValue.clamp(2000, 2040);
                  }),
                ),
                Text('valeur actuelle: $_currentIntValue'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = _currentIntValue + 1;
                    _currentIntValue = newValue.clamp(2000, 2040);
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
