//import 'package:auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/helper/oga_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/helper.dart';
import '../../../helper/oga_colors.dart';
import '../../../models/occupant.dart';
import '../../widgets/oga_scaffold.dart';

class OccupantDetails extends StatefulWidget {
  const OccupantDetails({super.key, required this.occupant});
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
    return OgaScaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: OgaColors.myLightBlue.shade100,
        ),
        title: const Text("Locataire info"),
        titleTextStyle: appBarTitleTextStyle,
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
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OgaTextWidget(
                          text:
                              "${widget.occupant.firstname}  ${widget.occupant.lastname}",
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [OgaTextWidget(text: widget.occupant.email)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OgaTextWidget(
                          text: widget.occupant.phoneNumber,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OgaTextWidget(
                            text:
                                "Caution: ${widget.occupant.deposit.toString()}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OgaTextWidget(
                            text:
                                "Avance: ${widget.occupant.rentAdvance.toString() ?? '-'}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OgaTextWidget(
                          text:
                              "Date d'entrée:${stringValueOfDate(widget.occupant.entryDate)}",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.occupant.docsNames.length,
                  itemBuilder: (builderContext, index) {
                    var docName = widget.occupant.docsNames[index] ?? "";
                    return ListTile(
                      title: Text(docName),
                      onTap: () async {
                        if (kDebugMode) {
                          print("printed url: $docName");
                        }
                        _launchUrl(docName);
                        //Get the path to the directory

                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DocumentDetails(documentName: docName)),
                        );*/
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> _launchUrl(String documentName) async {
    var url = await _getUrl(documentName);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<Uri> _getUrl(String documentName) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final docRef = storageRef.child(userID).child(documentName);
    var url = Uri.parse(await docRef.getDownloadURL());
    return url;
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

class OgaTextWidget extends StatelessWidget {
  const OgaTextWidget({
    super.key,
    required this.text,
    this.textSize,
    this.textColor,
    this.textStyle,
  });
  final String text;
  final double? textSize;
  final Color? textColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ??
          GoogleFonts.montserrat(
              fontSize: textSize ?? 20,
              color: textColor ?? OgaColors.blueButton),
    );
  }
}

class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
