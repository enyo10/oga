import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oga/helper/oga_colors.dart';
import 'package:oga/models/apartment.dart';
import 'package:oga/models/occupant.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../../helper/helper.dart';
import '../../models/house.dart';
import 'image_item.dart';

class AddOccupant extends StatefulWidget {
  final Apartment apartment;
  final House house;
  final Occupant? occupant;
  const AddOccupant(
      {Key? key, required this.apartment, required this.house, this.occupant})
      : super(key: key);

  @override
  State<AddOccupant> createState() => _AddOccupantState();
}

class _AddOccupantState extends State<AddOccupant> {
  final TextEditingController _firstnameTextController =
      TextEditingController();

  final TextEditingController _lastnameTextEditController =
      TextEditingController();
  final TextEditingController _depositTextEditController =
      TextEditingController();
  final TextEditingController _advanceTextEditController =
      TextEditingController();
  final TextEditingController _emailTextEditController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditController =
      TextEditingController();

  String date = "";
  DateTime selectedDate = DateTime.now();
  DateTime leaseDate = DateTime.now();
  late Apartment _apartment;
  late Occupant? _occupant;

  final List<XFile> _files = [];
  final List<dynamic> _imagesItems = [];
  final ImagePicker _imagePicker = ImagePicker();

  PDFDocument? _scannedDocument;
  File? _scannedDocumentFile;
  File? _scannedImage;

  @override
  void initState() {
    _apartment = widget.apartment;
    _occupant = widget.occupant;
    if (_occupant != null) {
      _updateData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_updateImageFromFiles();
    var appBarText = _hasOccupant ? "Actualiser occupant" : "Ajouter occupant";
    var buttonLabel = _hasOccupant ? "Actualiser" : "Ajouter";

    return Container(
      padding: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    appBarText,
                    style: const TextStyle(
                      fontSize: 20,
                      color: OgaColors.myLightBlue,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    color: Colors.blueAccent,
                    onPressed: () async {
                      await _showPicker(context);
                    },
                    icon: const Icon(Icons.photo_library),
                  )
                ],
              )
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await _addOccupant();
              if (!mounted) return;
              Navigator.of(context).pop(_occupant);
            },
            //   icon: const Icon(Icons.send),
            label: Text(
              buttonLabel,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _occupant == null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _firstnameTextController,
                        decoration: const InputDecoration(
                          labelText: "Nom",
                          border: OutlineInputBorder(),
                          hintText: 'Nom du locataire',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _lastnameTextEditController,
                        decoration: const InputDecoration(
                          labelText: "Premon ",
                          border: OutlineInputBorder(),
                          hintText: 'Pr??nom du locataire',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _phoneNumberTextEditController,
                        decoration: const InputDecoration(
                          labelText: 'T??l??phone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _emailTextEditController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _advanceTextEditController,
                        decoration: const InputDecoration(
                          labelText: "Avance",
                          border: OutlineInputBorder(),
                          hintText: 'Avance sur loyer',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^-?\d*\.?\d*)')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _depositTextEditController,
                        decoration: const InputDecoration(
                          labelText: "Caution",
                          border: OutlineInputBorder(),
                          hintText: 'D??pot',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^-?\d*\.?\d*)')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: const Text("Date d'entr??e"),
                          ),
                          const SizedBox(
                            width: 40.0,
                          ),
                          Text(
                            stringValueOfDate(selectedDate),
                          )
                        ],
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _imagesItems.length,
                        itemBuilder: (context, index) {
                          return _imagesItems[index];
                        },
                      ),
                    ),
                  ],
                ))
            : Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _phoneNumberTextEditController,
                      decoration: const InputDecoration(
                        labelText: 'T??l??phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) => setState(() {}),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _emailTextEditController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String value) => setState(() {}),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _updateData() {
    Occupant occupant = _occupant!;
    _firstnameTextController.text = occupant.firstname;
    _lastnameTextEditController.text = occupant.lastname;
    _phoneNumberTextEditController.text = occupant.phoneNumber;
    _emailTextEditController.text = occupant.email;
  }

  _saveOccupant(Occupant occupant) async {
    var houseCollection = FirebaseFirestore.instance.collection('houses');
    CollectionReference occupantCollection =
        FirebaseFirestore.instance.collection('occupants');

    var id = occupant.id;

    await occupantCollection.doc(id).set(_occupant!.toMap()).then((value) {
      for (int i = 0; i < widget.house.apartments.length; i++) {
        if (widget.house.apartments[i].id == widget.apartment.id) {
          widget.house.apartments[i].occupantId = id;
        }
      }
    });

    await houseCollection
        .doc(widget.house.id)
        .update(widget.house.toMap())
        .then((value) {
      showMessage(context, "Modification success");
    }).onError((error, stackTrace) {
      showMessage(context, error.toString());
    });
  }

  Occupant _createOccupant() {
    CollectionReference occupantCollection =
        FirebaseFirestore.instance.collection('occupants');

    String firstname = _firstnameTextController.text;
    String lastname = _lastnameTextEditController.text;
    String email = _emailTextEditController.text;
    String phone = _phoneNumberTextEditController.text;
    double deposit = double.parse(_depositTextEditController.text);
    double rentAdvance = double.parse(_advanceTextEditController.text);
    var apartmentId = widget.apartment.id;
    var id = occupantCollection.doc().id;

    return Occupant(
        id: id,
        apartmentId: apartmentId,
        firstname: firstname,
        lastname: lastname,
        entryDate: selectedDate,
        rentAdvance: rentAdvance,
        deposit: deposit,
        phoneNumber: phone,
        email: email);
  }

  Future<void> _addOccupant() async {
    var occupant = _createOccupant();

    if (_files.isNotEmpty) {
      FirebaseStorage storage = FirebaseStorage.instance;
      for (XFile xFile in _files) {
        var file = File(xFile.path);

        var docName = path.basename(file.path);

        try {
          var currentUser = FirebaseAuth.instance.currentUser;

          var fileStorage = storage.ref().child("${currentUser!.uid}/$docName");
          await fileStorage.putFile(file);
          occupant.docsNames.add(docName);
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      }
      _occupant = occupant;
      _saveOccupant(_occupant!);
    } else {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(" Vous n'avez pas ajout?? le contrat"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          }).then((value) {
        if (value == 'OK') {
          _occupant = occupant;
          _saveOccupant(_occupant!);
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(widget.house.constructionYear),
      lastDate: DateTime(2040),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  Future<void> _leaseTerminationDate() async {
    var actualOccupantEntryDate = widget.occupant!.entryDate;
    var initialDate = DateTime.now();
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: actualOccupantEntryDate,
        lastDate: DateTime(2040));

    if (selected != null && selected != leaseDate) {
      setState(() {
        leaseDate = selected;
      });
    }
  }

  bool get _hasOccupant => _apartment.occupantId != null;

  Future<void> _showPicker(context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('Ajouter un PDF'),
                  onTap: () async {
                    _openPdfScanner(context);
                    /*await _chooseImage(ImageSource.gallery).then((value) {
                      Navigator.of(context).pop();
                    });*/
                  },
                ),
                Builder(
                  builder: (context) {
                    return ListTile(
                      onTap: () => _openImageScanner(context),
                      leading: const Icon(Icons.image),
                      title: const Text('Image'),
                    );
                  },
                )

                /* await _chooseImage(ImageSource.camera).then((value) {
                      Navigator.of(context).pop();
                    });*/
              ],
            ),
          );
        });
  }

  /* Future<void> _chooseImage(ImageSource imageSource) async {
    await _imagePicker.pickImage(source: imageSource).then((value) {
      if (value != null) {
        setState(() {
          _files.add(value);
        });
      }
    });
  }*/

  _onRemoveImage(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  /*_updateImageFromFiles() {
    _imagesItems.clear();
    if (_files.isNotEmpty) {
      for (int i = 0; i < _files.length; i++) {
        _imagesItems.add(
          ImageItem(
            file: File(_files[i].path),
            index: i,
            onDeleteItem: () {
              _onRemoveImage(i);
            },
          ),
        );
      }
    }
  }*/

  _openPdfScanner(BuildContext context) async {
    var doc = await DocumentScannerFlutter.launchForPdf(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Continuer",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "Only 1 Page",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
            "Only {PAGES_COUNT} Page"
      },
      // source: ScannerFileSource.CAMERA
    );
    if (doc != null) {
      _scannedDocument = null;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 100));
      _scannedDocumentFile = doc;
      _scannedDocument = await PDFDocument.fromFile(doc);
      _imagesItems.add(_scannedDocument);
      setState(() {});
    }
  }

  _openImageScanner(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context,
        // source: ScannerFileSource.CAMERA,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Continuer",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });
    if (image != null) {
      //  _scannedImage = image;
      _imagesItems.add(ImageItem(file: image, onDeleteItem: () {}));
      setState(() {});
    }
  }
}
