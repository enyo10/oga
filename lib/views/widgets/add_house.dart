import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:oga/views/widgets/color_picker.dart';
import '../../helper/helper.dart';

class AddHouse extends StatefulWidget {
  const AddHouse({
    Key? key,
  }) : super(key: key);

  @override
  State<AddHouse> createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String date = "";
  DateTime _selectedDate = DateTime.now();
  dynamic _selectedColorData = colorMap.entries.first;
  CollectionReference houses = FirebaseFirestore.instance.collection('houses');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
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
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () async {
                  await _addHouse()
                      .then((value) => Navigator.of(context).pop());
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(fontSize: 25),
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
                //content of modal bottom
                // sheet
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
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
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
                    Padding(
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
                const SizedBox(
                  height: 20,
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
                Padding( // this is new
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addHouse() async {
    var name = _nameController.text;
    var desc = _descriptionController.text;
    var address = _addressController.text;

    if (!_hasData()) {
      showMessage(context, " Saisir les données");
      return;
    } else {
      var uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        dynamic apartments = [];
        dynamic data = {
          'uid': uid,
          'name': name,
          'desc': desc,
          'address': address,
          'colorKey': _selectedColorData.key,
          'constructionYear': _selectedDate.year,
          "apartments":
              apartments.map((apartment) => apartment.toMap()).toList(),
        };

        return houses.add(data).then((value) {
          _clearController();
          showMessage(context, "Maison bien ajoutée");
        }).onError((error, stackTrace) {
          showMessage(context, "Erreur lors d'ajout de maison");
        });
      } else {
        return;
      }
      /* var id = houses.doc().id;

      dynamic apartments = [];
      var house = {
        'id': id,
        'name': name,
        'desc': desc,
        'address': address,
        'colorKey': _selectedColorData.key,
        'constructionYear': _selectedDate.year,
        "apartments": apartments.map((apartment) => apartment.toMap()).toList(),
      };
      return houses.doc(id).set(house).then((value) {
        _clearController();
        showMessage(context, "Maison bien ajoutée");
      }).onError((error, stackTrace) {
        showMessage(context, "Erreur lors d'ajout");
      });*/
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

  bool _hasData() {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _addressController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
