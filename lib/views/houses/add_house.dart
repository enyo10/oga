import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:oga/helper/oga_colors.dart';

import 'package:path/path.dart' as path;
import '../../../helper/helper.dart';
import '../../widgets/color_picker.dart';
import '../../widgets/image_item.dart';
import '../../widgets/oga_elevated_button.dart';

class AddHouse extends StatefulWidget {
  const AddHouse({
    super.key,
  });

  @override
  State<AddHouse> createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String date = "";
  DateTime _selectedDate = DateTime.now();
  dynamic _selectedColorData = colorMap.entries.first;
  CollectionReference houses = FirebaseFirestore.instance.collection('houses');
  final ImagePicker _imagePicker = ImagePicker();
  File? _file;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          topLeft: Radius.circular(40.0),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false, // this is new
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: OgaElevatedButton(
                gradient: LinearGradient(
                  colors: [
                    OgaColors.myLightBlue.shade50,
                    OgaColors.myLightBlue.shade900,
                  ],
                ),
                onPressed: () async {
                  if ((_formKey.currentState!.validate())) {
                    await _saveHouse();
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Ajouter',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),

            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8.0),
                  child: Center(
                    child: Text(
                      'Maison',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Divider(
                    thickness: 5, // thickness of the line
                    indent: 20, // empty space to the leading edge of divider.
                    endIndent:
                        20, // empty space to the trailing edge of the divider.
                    //  color: Colors.red, // The color to use when painting the line.
                    height: 20, // The divider's height extent.
                    color: Colors.blue,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validate,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            hintText: 'Address',
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validate,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validate,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: const Text('Construction date'),
                      ),
                      const SizedBox(
                        width: 40.0,
                      ),
                      Text(
                        "${_selectedDate.year}",
                      )
                    ],
                  ),
                ),
                _file == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _showPicker(context);
                            },
                            iconSize: 35,
                            icon: const Icon(Icons.attach_file),
                          ),
                        ],
                      )
                    : ImageItem(
                        file: File(_file!.path),
                        showImage: true,
                        onDeleteItem: () {
                          _removeImage();
                        },
                      ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    leading: Icon(
                      Icons.lens,
                      color: _selectedColorData.value,
                    ),
                    title: Text(
                      _selectedColorData.key,
                      style: TextStyle(
                        color: _selectedColorData.value,
                      ),
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return ColorPicker(colorData: _selectedColorData);
                        },
                      ).then((selectedValue) {
                        if (selectedValue != null) {
                          setState(() {
                            _selectedColorData = selectedValue;
                          });
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  // this is new
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _storeImage(File file) async {
    var fileName = path.basename(file.path);
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      var currentUser = FirebaseAuth.instance.currentUser;

      var fileStorage = storage.ref().child("${currentUser!.uid}/$fileName");
      await fileStorage.putFile(file).then(
          (p0) => showMessage(context, "Document enrégistré avec succès"));
    } on FirebaseException catch (error) {
      showMessage(context, error.toString());
    }
  }

  Future<Map<String, dynamic>?> _createHouse() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    final name = _nameController.text;
    final desc = _descriptionController.text;
    final address = _addressController.text;
    final String imageName = _file != null ? path.basename(_file!.path) : "";

    if (uid != null) {
      dynamic apartments = [];
      dynamic data = {
        'uid': uid,
        'name': name,
        'desc': desc,
        'imageName': imageName,
        'address': address,
        'colorKey': _selectedColorData.key,
        'constructionYear': _selectedDate.year,
        'apartments': apartments.map((apartment) => apartment.toMap()).toList(),
      };
      return data;
    }
    return null;
  }

  Future<void> _saveHouse() async {
    String? store = 'OK';
    var house = await _createHouse();

    if (house != null) {
      if (_file != null) {
        await _storeImage(_file!);
      } else {
        await showDialog<String>(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                content: const Text(" Vous n'avez pas ajouté d'image."
                    "Voulez vous continuer ?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('Oui'),
                  ),
                ],
              );
            }).then((value) {
          store = value;
        });
      }
    }
    if (store == 'OK') {
      return houses.add(house).then(
        (value) async {
          _clearController();
          showMessage(context, "Maison bien ajoutée");
          Navigator.of(context).pop();
        },
      ).onError(
        (error, stackTrace) {
          showMessage(context, "Erreur lors d'ajout de maison");
        },
      );
    } else {
      return;
    }
  }

  void _clearController() {
    _addressController.clear();
    _descriptionController.clear();
    _nameController.clear();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selectedDate =
        await showMonthPicker(context: context, initialDate: _selectedDate);
    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Future<void> _chooseImage(ImageSource imageSource) async {
    await _imagePicker.pickImage(source: imageSource).then((value) {
      if (value != null) {
        setState(() {
          _file = File(value.path);
        });
      }
    });
  }

  void _removeImage() {
    setState(() {
      _file = null;
    });
  }

  Future<void> _showPicker(BuildContext context) {
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

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return " Renseigner des données";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
  }
}
