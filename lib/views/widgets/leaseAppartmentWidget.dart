import 'package:flutter/material.dart';
import 'package:oga/models/apartment.dart';

import '../../models/house.dart';
import '../../models/occupant.dart';

/*
class LeaseApartmentWidget extends StatefulWidget {
  const LeaseApartmentWidget(
      {Key? key,
      required this.occupant,
      required this.house,
      required this.apartment})
      : super(key: key);
  final Occupant occupant;
  final House house;
  final Apartment apartment;

  @override
  State<LeaseApartmentWidget> createState() => _LeaseApartmentWidgetState();
}

class _LeaseApartmentWidgetState extends State<LeaseApartmentWidget> {
  DateTime leaseDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
          child: const Text(
            "Ajouter",
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _leaseDate();
                    },
                    child: const Text("Release date"),
                  ),
                  Text("${leaseDate ?? ''}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _leaseDate() async {
    var initialDate = DateTime.now();
    var firstDate = widget.occupant.entryDate;
    var lastDate = DateTime(2040);

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (selected != null && selected != leaseDate) {
      setState(() {
        leaseDate = selected;
      });
    }
  }
}
*/
