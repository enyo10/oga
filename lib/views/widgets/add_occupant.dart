import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    _apartment = widget.apartment;
    _occupant = widget.occupant;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateImageFromFiles();
    var appBarText = _hasOccupant ? "Rélisier bail" : "Ajouter occupant";
    var buttonLabel = _hasOccupant ? "Résilier" : "Ajouter";

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
          title: Text(
            appBarText,
            style: const TextStyle(
              fontSize: 20,
              color: OgaColors.myLightBlue,
            ),
          ),
          // backgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              color: Colors.blueAccent,
              onPressed: () async {
                await _showPicker(context);
              },
              icon: const Icon(Icons.photo_library),
            )
          ],
        ),
        /* resizeToAvoidBottomInset: false,*/
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await _addOccupant();
              if (!mounted) return;
              Navigator.of(context).pop(_occupant);
            },
            //   icon: const Icon(Icons.send),
            label: Text(
              buttonLabel,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: !_hasOccupant
              ? Column(
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
                          hintText: 'Prénom du locataire',
                        ),
                      ),
                    ),
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
                          hintText: 'Dépot',
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
                            child: const Text("Date d'entrée"),
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
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _leaseTerminationDate();
                          },
                          child: const Text("Release date"),
                        ),
                        Text(stringValueOfDate(leaseDate)),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _addOccupant() async {
    CollectionReference occupantCollection =
        FirebaseFirestore.instance.collection('occupants');
    var houseCollection = FirebaseFirestore.instance.collection('houses');

    if (widget.occupant != null) {
      for (int i = 0; i < widget.house.apartments.length; i++) {
        if (widget.house.apartments[i].occupantId == widget.occupant!.id) {
          widget.house.apartments[i].occupantId = null;
          widget.occupant!.releaseDate = leaseDate;

          await occupantCollection
              .doc(widget.occupant!.id)
              .update(widget.occupant!.toMap())
              .then((value) {
            _occupant = null;
          });
        }
      }
    } else {
      String firstname = _firstnameTextController.text;
      String lastname = _lastnameTextEditController.text;
      String email = _emailTextEditController.text;
      String phone = _phoneNumberTextEditController.text;
      double deposit = double.parse(_depositTextEditController.text);
      double rentAdvance = double.parse(_advanceTextEditController.text);
      var apartmentId = widget.apartment.id;

      var id = occupantCollection.doc().id;
      _occupant = Occupant(
          id: id,
          apartmentId: apartmentId,
          firstname: firstname,
          lastname: lastname,
          entryDate: selectedDate,
          rentAdvance: rentAdvance,
          deposit: deposit,
          phoneNumber: phone,
          email: email);
      if (_files.isNotEmpty) {
        FirebaseStorage storage = FirebaseStorage.instance;
        for (XFile xFile in _files) {
          var file = File(xFile.path);
          var docName = "doc${DateTime.now().hashCode}";

          try {
           await storage.ref().child("documents/$docName").putFile(file);
            _occupant?.docsNames.add(docName);
          } on FirebaseException catch (error) {
            if (kDebugMode) {
              print(error);
            }
          }
        }
      }

      await occupantCollection.doc(id).set(_occupant!.toMap()).then((value) {
        for (int i = 0; i < widget.house.apartments.length; i++) {
          if (widget.house.apartments[i].id == widget.apartment.id) {
            widget.house.apartments[i].occupantId = id;
          }
        }
      });
    }

    await houseCollection
        .doc(widget.house.id)
        .update(widget.house.toMap())
        .then((value) {
      showMessage(context, "Modification success");
    }).onError((error, stackTrace) {
      showMessage(context, error.toString());
    });
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
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    await _chooseImage(ImageSource.gallery).then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    await _chooseImage(ImageSource.camera).then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _chooseImage(ImageSource imageSource) async {
    await _imagePicker.pickImage(source: imageSource).then((value) {
      if (value != null) {
        var name = path.basename(value.path);
        print(" image name $name");

        setState(() {
          _files.add(value);
        });
      }
    });
  }

  _onRemoveImage(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  _updateImageFromFiles() {
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
  }
}
