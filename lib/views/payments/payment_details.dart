import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:oga/views/screens/image_enlargement.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/models/occupant.dart';

import '../../../helper/helper.dart';
import '../../../models/payment.dart';
import '../../widgets/info_widget.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails(
      {super.key, required this.payment, required this.occupant});

  final Payment payment;
  final Occupant? occupant;

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var desc = (widget.payment.desc == '')
        ? "Aucun commentaire n'a été laissé"
        : widget.payment.desc;
    return SafeArea(
      child: Scaffold(
        /* appBar: AppBar(
          backgroundColor: const Color(0xFFEFFFFD),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.red,
          //  opacity: 60,
          //  size: 50

          ),
        ),*/
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InfoWidget(
                      data: widget.payment.paymentPeriod.toString(),
                      text: 'Mois',
                    ),
                    InfoWidget(
                        data: widget.payment.amount.toString(),
                        text: "Montant"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InfoWidget(
                            data: stringValueOfDate(widget.payment.paymentDate),
                            text: "Date payement"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Commentaire: ",
                            // style: TextStyle(fontSize: 20),
                            style: GoogleFonts.courgette(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        desc,
                        /*style: const TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),*/
                        style: GoogleFonts.courgette(
                            textStyle: const TextStyle(
                          fontSize: 20,
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];

                        String url = image['url'];
                        var first = (url.split('?').first);
                        var imageName = first.split("%2F").last;
                        print(" image name ....  $imageName");

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                              elevation: 10,
                              //margin: const EdgeInsets.all(20),
                              child: GestureDetector(
                                onDoubleTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ImageEnlargement(
                                        imageUrl: image['url']);
                                  }));
                                },
                                child: Hero(
                                  tag: imageName,
                                  child: Image.network(
                                    image['url'],
                                    width: 300,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                              /*GestureDetector(
                              onDoubleTap: () {
                                if (_animationController.isCompleted) {
                                  _animationController.reverse();
                                } else {
                                  _animationController.forward();
                                }
                              },
                              child: Transform(
                                transform: Matrix4.diagonal3(
                                  a.Vector3(_animation.value, _animation.value,
                                      _animation.value),
                                ),
                                alignment: FractionalOffset.center,
                                child: ExtendedImage.network(
                                  image['url'],
                                  width: 350,
                                  height: 300,
                                  fit: BoxFit.fill,
                                  cache: true,
                                ),

                                */ /*Image.network(
                                  image['url'],
                                  width: 350,
                                  height: 300,
                                  fit: BoxFit.fill,

                                ),*/ /* */ /*
                              ),*/ /*
                              ),
                            ),*/
                              ),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    var hash = widget.payment.paymentId.hashCode;

    var storageDirectory =
        getStorageName(widget.occupant!, widget.payment.paymentPeriod);

    FirebaseStorage storage = FirebaseStorage.instance;
    List<Map<String, dynamic>> files = [];

    final ListResult result =
        await storage.ref().child("images/$storageDirectory/$hash").list();

    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }


}
