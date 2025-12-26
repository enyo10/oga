import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../../models/occupant.dart';
import 'occupant_card.dart';

class
OccupantsView extends StatefulWidget {
  const OccupantsView({super.key, required this.apartmentId});
  final String apartmentId;

  @override
  State<OccupantsView> createState() => _OccupantsViewState();
}

class _OccupantsViewState extends State<OccupantsView> {
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
