import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Occupants extends StatefulWidget {
  const Occupants({super.key});

  @override
  State<Occupants> createState() => _OccupantsState();
}

class _OccupantsState extends State<Occupants> {
  late Stream<QuerySnapshot> _occupantStream;

  @override
  void initState() {
    _occupantStream =
        FirebaseFirestore.instance.collection('occupants').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _occupantStream,
          builder: (BuildContext cs, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 30),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 30),
                ),
              );
            }
            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text(
                  " Has no data",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${snapshot.data!.size}",
                  style: const TextStyle(fontSize: 45),
                ),
              ),
            );
          }),
    );
  }
}
