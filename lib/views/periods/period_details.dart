import 'package:flutter/material.dart';
import 'package:oga/models/apartment.dart';

import '../../../helper/helper.dart';

class PeriodDetails extends StatelessWidget {
  const PeriodDetails({super.key, required this.data, required this.apartment});
  final Data data;
  final Apartment apartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(20),
          child: Column(
            children: [

            ],
          ),
    ));
  }
}
