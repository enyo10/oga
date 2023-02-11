import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oga/views/widgets/occupant_card.dart';

import '../../models/occupant.dart';

class Occupants extends StatefulWidget {
  const Occupants({Key? key, required this.apartmentId}) : super(key: key);
  final String apartmentId;

  @override
  State<Occupants> createState() => _OccupantsState();
}

class _OccupantsState extends State<Occupants> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
          future: _loaData(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (!querySnapshot.hasData) {
              return const Center(child: Text("No data"));
            }

            if (querySnapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading ");
            }

            return ListView(
              children:
                  querySnapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                final occupant = Occupant.fromMap(data);
                return OccupantCard(occupant: occupant);
              }).toList(),
            );
          }),
    );
  }

  Future<QuerySnapshot> _loaData() async {
  return await FirebaseFirestore.instance
        .collection('occupants')
        .where('apartmentId', isEqualTo: widget.apartmentId)
        .get();
  }
}
