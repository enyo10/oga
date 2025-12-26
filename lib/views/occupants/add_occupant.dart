import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oga/helper/oga_colors.dart';
import 'package:oga/models/apartment.dart';
import 'package:oga/models/occupant.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../../../helper/helper.dart';
import '../../../models/house.dart';
import '../../widgets/image_item.dart';


class AddOccupant extends StatefulWidget {
  final Apartment apartment;
  final House house;
  final Occupant? occupant;
  const AddOccupant({
    super.key,
    required this.apartment,
    required this.house,
    this.occupant,
  });

  @override
  State<AddOccupant> createState() => _AddOccupantState();
}

class _AddOccupantState extends State<AddOccupant> {
  CollectionReference occupantCollection = FirebaseFirestore.instance
      .collection('occupants');

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

  final List<dynamic> _documentsItems = [];
  final _formKey = GlobalKey<FormState>();

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
          title: Text(
            appBarText,
            style: const TextStyle(fontSize: 20, color: OgaColors.myLightBlue),
          ),
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _storeDocumentAndSaveOccupant().then(
                  (value) => Navigator.of(context).pop(_occupant),
                );
                /*if (!mounted) return;
                Navigator.of(context).pop(_occupant);*/
              }
            },
            //   icon: const Icon(Icons.send),
            label: Text(buttonLabel, style: const TextStyle(fontSize: 22)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body:
            _occupant == null
                ? SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _firstnameTextController,
                            decoration: const InputDecoration(
                              labelText: "Nom",
                              border: OutlineInputBorder(),
                              hintText: 'Nom du locataire',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer le nom';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _lastnameTextEditController,
                            decoration: const InputDecoration(
                              labelText: "Premon ",
                              border: OutlineInputBorder(),
                              hintText: 'Prénom du locataire',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer le prénom';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phoneNumberTextEditController,
                            decoration: const InputDecoration(
                              labelText: 'Téléphone',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (String value) => setState(() {}),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
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
                          child: TextFormField(
                            controller: _advanceTextEditController,
                            decoration: const InputDecoration(
                              labelText: "Avance",
                              border: OutlineInputBorder(),
                              hintText: 'Avance sur loyer',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'(^-?\d*\.?\d*)'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _depositTextEditController,
                            decoration: const InputDecoration(
                              labelText: "Caution",
                              border: OutlineInputBorder(),
                              hintText: 'Dépot',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'(^-?\d*\.?\d*)'),
                              ),
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
                                child: const Text("Date d'entrée"),
                              ),
                              const SizedBox(width: 40.0),
                              Text(stringValueOfDate(selectedDate)),
                            ],
                          ),
                        ),
                        _documentsItems.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      await _scanDocumentToPDF(context);
                                    },
                                    icon: const Icon(Icons.attach_file),
                                  ),
                                ],
                              ),
                            )
                            : Card(
                              elevation: 0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _documentsItems.length,
                                itemBuilder: (context, index) {
                                  var file = _documentsItems[index];
                                  return ImageItem(
                                    file: file,
                                    onDeleteItem: () {
                                      _onRemoveImage(index);
                                    },
                                  );
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                )
                : Column(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _phoneNumberTextEditController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
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

  Occupant _createOccupant() {
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
      email: email,
      rentalAgreement: '',
    );
  }

  Future<void> _saveOccupant(Occupant occupant) async {
    var houseCollection = FirebaseFirestore.instance.collection('houses');
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
        })
        .onError((error, stackTrace) {
          showMessage(context, error.toString());
        });
  }

  Future<void> _storeDocumentAndSaveOccupant() async {
    var occupant = _createOccupant();

    if (_documentsItems.isNotEmpty) {
      File file = _documentsItems.first;
      var fileName = path.basename(file.path);
      FirebaseStorage storage = FirebaseStorage.instance;

      try {
        var currentUser = FirebaseAuth.instance.currentUser;

        var fileStorage = storage.ref().child("${currentUser!.uid}/$fileName");
        await fileStorage.putFile(file);
        occupant.rentalAgreement = fileName;
      } on FirebaseException catch (error) {
        showMessage(context, error.toString());
      }
      _occupant = occupant;
      return _saveOccupant(_occupant!);
    } else {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(" Vous n'avez pas ajouté le contrat"),
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
        },
      ).then((value) {
        if (value == 'OK') {
          _occupant = occupant;
          return _saveOccupant(_occupant!);
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
      lastDate: DateTime(2040),
    );

    if (selected != null && selected != leaseDate) {
      setState(() {
        leaseDate = selected;
      });
    }
  }

  bool get _hasOccupant => _apartment.occupantId != null;

  Future<void> _scanDocumentToPDF(BuildContext context) async {
/*    File? file = await DocumentScannerFlutter.launchForPdf(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Continuer",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "OK",
      },
    );
    if (file != null) {
      String dir = path.dirname(file.path);
      String newPath = path.join(dir, 'contrat.pdf');
      var f = file.renameSync(newPath);
      setState(() {
        _documentsItems.add(f);
      });
    }*/
  }

  _onRemoveImage(int index) {
    setState(() {
      _documentsItems.removeAt(index);
    });
  }
}
