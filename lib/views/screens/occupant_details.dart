import 'package:auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/helper.dart';
import '../../helper/oga_colors.dart';
import '../../models/occupant.dart';
import '../widgets/oga_scaffold.dart';

class OccupantDetails extends StatefulWidget {
  const OccupantDetails({Key? key, required this.occupant}) : super(key: key);
  final Occupant occupant;

  @override
  State<OccupantDetails> createState() => _OccupantDetailsState();
}

class _OccupantDetailsState extends State<OccupantDetails> {
  List<String> urls = [];
  @override
  void initState() {
    getUrls().then((value) => urls = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OgaScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Locataire info"),
          titleTextStyle:
              GoogleFonts.montserrat(fontSize: 30, color: OgaColors.grey2),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                color: OgaColors.grey2 ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.occupant.firstname,),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(widget.occupant.lastname)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.occupant.email),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(widget.occupant.phoneNumber)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Caution:"),
                        Text(widget.occupant.deposit.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Avance:"),
                        Text(widget.occupant.rentAdvance.toString())
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Date d'entrée:"),
                const SizedBox(
                  width: 10,
                ),
                Text(stringValueOfDate(widget.occupant.entryDate))
              ],
            ),
            Row(
              children: [],
            )
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Future<List<String>> getUrls() async {
    List<String> urls = [];
    var currentUser = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child(currentUser!.uid);
    if (kDebugMode) {
      print(" image reference $imagesRef");
    }
    for (int i = 0; i < widget.occupant.docsNames.length; i++) {
      final imageUrl = await storageRef
          .child("${currentUser.uid}/${widget.occupant.docsNames.first}")
          .getDownloadURL();
      urls.add(imageUrl);
    }
    return urls;
  }
}
