import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/oga_scaffold.dart';

class DocumentDetails extends StatelessWidget {
  const DocumentDetails({super.key, required this.documentName});
  final String documentName;

  @override
  Widget build(BuildContext context) {
    
    _getImage();
    return OgaScaffold(
      appBar: AppBar(title: const Text("Document"),),
      body: SingleChildScrollView(
        child: Center(
          child: Image.network(""),
        ),
      ),
    );
  }
  Future<void> _launchUrl() async {
    var url = await _getUrl();
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  Future<Uri>_getUrl() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final docRef = storageRef.child(userID).child(documentName);
    var url = Uri.parse(await docRef.getDownloadURL());
    return url;
  }
  _getImage() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final docRef = storageRef.child(userID).child(documentName);
    var url = Uri.parse(await docRef.getDownloadURL());
    if (kDebugMode) {
      print(url);
    }
  }

  _loadDocument() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final isdocumentRef = storageRef.child("$userID/$documentName");

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/images/$documentName";
    final file = File(filePath);

    final downloadTask = isdocumentRef.writeToFile(file);

    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
  }

  _loadImage() async {
    //current user id
    final userID = FirebaseAuth.instance.currentUser!.uid;

    //collect the image name
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('data_user')
        .doc('user')
        .collection('personal_data')
        .doc(userID)
        .get();

    //a list of images names (i need only one)
    var fileName = variable['path_profile_image'];

    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images/user/profile_images/$userID")
        .child(fileName[0]);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    /* setState(() {
      url: url
    })*/
  }
}
