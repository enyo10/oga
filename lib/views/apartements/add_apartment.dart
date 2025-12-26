import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:oga/models/apartment.dart';
import 'package:oga/models/rent_period.dart';

import '../../../helper/helper.dart';
import '../../../models/house.dart';
import '../../widgets/color_picker.dart';

class AddApartment extends StatefulWidget {
  const AddApartment({
    super.key,
    required this.house,
    this.apartment,
  });
  final House house;
  final Apartment? apartment;

  @override
  State<AddApartment> createState() => _AddApartmentState();
}

class _AddApartmentState extends State<AddApartment> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  String date = "";
  DateTime _selectedDate = DateTime.now();
  dynamic _selectedColorData = colorMap.entries.first;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference houseCollection;

  @override
  void initState() {
    super.initState();
    houseCollection = FirebaseFirestore.instance.collection("houses");

    _setValue();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var status = widget.apartment == null
        ? 'Date mise en location'
        : "Date de modification";
    return Container(
      height: size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          topLeft: Radius.circular(40.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              //content of modal bottom
              // sheet
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 8.0),
                child: Center(
                  child: Text(
                    'Appartement',
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
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.apartment == null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
              /*    Visibility(
                    visible: widget.apartment == null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          hintText: 'Address',
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _rentController,
                      // keyboardType: TextInputType.number,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^\d*\.?\d*)')),
                      ],
                      // Only numbers can be entered
                      decoration: const InputDecoration(
                        hintText: 'rent',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
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
                      child: Text(status),
                    ),
                    const SizedBox(
                      width: 40.0,
                    ),
                    Text(
                      stringValueOfDate(_selectedDate),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
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
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                    top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    widget.apartment == null
                        ? await _addApartment()
                        : await _updateApartment();

                    if (!mounted) return;
                    Navigator.of(context).pop(widget.house);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addApartment() async {
    var name = _nameController.text;
    var desc = _descriptionController.text;
    var rentAmount = double.parse(_rentController.text);
    Rent rent = Rent(startDate: _selectedDate, value: rentAmount);

    if (!_hasData()) {
      showMessage(context, " Saisir les données");
      return;
    } else {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        var id = houseCollection
            .doc(widget.house.id)
            .collection("apartments")
            .doc()
            .id;

        var apartment = Apartment(
            name: name,
            id: id,
            description: desc,
            backgroundColor: colorMap[_selectedColorData.key] ?? Colors.white);

        apartment.rents.add(rent);
        widget.house.apartments.add(apartment);

        await houseCollection
            .doc(widget.house.id)
            .update(widget.house.toMap())
            .then((value) {
          _clearController();
          showMessage(context, "Appartement ajouté avec succès");
        }).onError((error, stackTrace) {
          showMessage(context, "Erreur lors d'ajout d'appartement");
        });
      } else {
        return;
      }
    }
  }

  Future<void> _updateApartment() async {
    if (!_hasData()) {
      showMessage(context, " Indiguer le nouveau loyer");
      return;
    }
    double rentAmount = double.parse(_rentController.text);

    double actualRent = widget.apartment!.getActualRent().value;

    if (rentAmount == actualRent) {
      showMessage(context, " L'actuel loyer est égal au montant indiqué");
      return;
    }
    Rent rent = Rent(startDate: _selectedDate, value: rentAmount);
    String id = widget.apartment!.id;
    var apartments = widget.house.apartments;

    for (int i = 0; i < apartments.length; i++) {
      if (apartments.elementAt(i).id == id) {
        apartments.elementAt(i).modifyRent(rent);
        break;
      }
    }
    await houseCollection
        .doc(widget.house.id)
        .update(widget.house.toMap())
        .then((value) {
      _clearController();
      showMessage(context, "Modification du loyer réussi");
    }).onError((error, stackTrace) {
      print("EEEReurrrr $stackTrace");
      if (kDebugMode) {
        print("EDDDDDDDD  $error");
      }
      showMessage(context, "Erreur lors de la modification");
    });
  }

  void _clearController() {
    _addressController.clear();
    _descriptionController.clear();
    _rentController.clear();
    _nameController.clear();
  }

  void _setValue() {
    if (widget.apartment != null) {
      _nameController.text = widget.apartment!.name;
      _descriptionController.text = widget.apartment!.description;
      //_addressController.text = widget.apartment!.;
      _rentController.text = widget.apartment!.getActualRent().value.toString();
    }
  }

  _selectDate(BuildContext context) async {
    var apartment = widget.apartment;

    var firstDate = apartment != null
        ? apartment.getActualRent().startDate
        : DateTime(widget.house.constructionYear);

    final DateTime? selectedDate = await showMonthPicker(
        context: context, initialDate: _selectedDate, firstDate: firstDate);

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  bool _hasData() {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _rentController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
