//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class DataListScreen extends StatefulWidget {
  final String collectionName;
  const DataListScreen({super.key, required this.collectionName});

  @override
  State<DataListScreen> createState() => DataListScreenState();
}

class DataListScreenState<T extends DataListScreen>
    extends State<DataListScreen> {
  late Stream<QuerySnapshot> dataStream;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    dataStream =
        FirebaseFirestore.instance
            .collection(widget.collectionName)
            .where('uid', isEqualTo: userId)
            .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
