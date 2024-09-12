import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oga/models/apartment.dart';

import '../../../helper/helper.dart';
import '../../../models/house.dart';
import '../../../models/occupant.dart';

class TerminateLease extends StatefulWidget {
  const TerminateLease(
      {super.key,
      required this.occupant,
      required this.house,
      required this.apartment});
  final Occupant occupant;
  final House house;
  final Apartment apartment;

  @override
  State<TerminateLease> createState() => _TerminateLeaseState();
}

class _TerminateLeaseState extends State<TerminateLease> {
  DateTime leaseDate = DateTime.now();

  //rkRqgcCIrfwbFvL1bdqm

  @override
  void initState() {
    _leaseDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: ElevatedButton(
          onPressed: () async {
            print("Will be done");

            await _terminateLease()
                .then((value) => Navigator.of(context).pop());
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
          child: const Text(
            "Valider",
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
                  Text(
                    stringValueOfDate(leaseDate),
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                    ),
                  )
                  // Text("$leaseDate "),
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

  /*Future<void> _setRemovedId() async {
    CollectionReference houseCollection =
        FirebaseFirestore.instance.collection('houses');

    widget.apartment.occupantId == null;
    for (int i = 0; i < widget.house.apartments.length; i++) {
      if (widget.house.apartments[i].id == widget.apartment.id) {
        widget.house.apartments[i].occupantId = "rkRqgcCIrfwbFvL1bdqm";
      }
    }

    await houseCollection
        .doc(widget.house.id)
        .update(widget.house.toMap())
        .then((value) {
      showMessage(context, "Modification success");
    }).onError((error, stackTrace) {
      showMessage(context, error.toString());
    });
  }*/

  Future<void> _terminateLease() async {
    CollectionReference houseCollection =
        FirebaseFirestore.instance.collection('houses');

    widget.apartment.occupantId == null;
    for (int i = 0; i < widget.house.apartments.length; i++) {
      if (widget.house.apartments[i].id == widget.apartment.id) {
        widget.house.apartments[i].occupantId = null;
      }
    }

    await houseCollection
        .doc(widget.house.id)
        .update(widget.house.toMap())
        .then((value) {
      showMessage(context, "Modification success");
    }).onError((error, stackTrace) {
      showMessage(context, error.toString());
    });
  }

  /*_updateOccupant() async {
    CollectionReference occupantsCollection =
        FirebaseFirestore.instance.collection('occupants');
    widget.occupant.releaseDate = leaseDate;

    await occupantsCollection
        .doc(widget.occupant.id)
        .update(widget.occupant.toMap())
        .then((value) {
      showMessage(context, "Occupant updated");
    }).onError((error, stackTrace) {
      showMessage(context, error.toString());
    });
  }*/
}
