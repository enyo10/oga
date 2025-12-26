import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:oga/models/apartment.dart';
import 'package:path/path.dart';

import '../../../helper/helper.dart';
import '../../../models/occupant.dart';
import '../../../models/payment.dart';
import '../../../models/period.dart';
import '../../widgets/image_item.dart';

class AddPayment extends StatefulWidget {
  final Occupant? occupant;
  final DateTime? paymentPeriod;
  final Apartment apartment;

  const AddPayment({
    super.key,
    required this.occupant,
    this.paymentPeriod,
    required this.apartment,
  });

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final List<XFile> _files = [];
  final List<dynamic> _imagesItems = [];
  final ImagePicker _imagePicker = ImagePicker();

  double amountInDollar = 0.0;
  late DateTime _selectedPaymentDate;
  late DateTime _selectedPeriodDate;
  bool _hasPeriod = false;

  @override
  void initState() {
    super.initState();

    _initPaymentPeriod();
    _selectedPaymentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var paymentPeriod =
        "${_selectedPeriodDate.month}/"
        "${_selectedPeriodDate.year}";
    _updateImageFromFiles();
    Size size = MediaQuery.of(context).size;
    var pad = size.width * 0.25;

    return Container(
      height: size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: ElevatedButton(
            onPressed: () async {
              await _addPayment(context);

              if (!mounted) return;
              Navigator.of(context).pop(widget.occupant);
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(100, 40),
            ),
            child: const Text("Ajouter", style: TextStyle(fontSize: 20)),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Ajouter payement",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          actions: [
            IconButton(
              color: Colors.blueAccent,
              onPressed: () async {
                await _showPicker(context);
              },
              icon: const Icon(Icons.photo_library),
            ),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Loyer :"
                        " ${widget.apartment.rent(_selectedPeriodDate.year, _selectedPeriodDate.month).value}"
                        " CFA",
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Payement ',
                          hintText: 'Enter payement en CFA',
                        ),
                        style: Theme.of(context).textTheme.labelLarge,
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
                      child: TextField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ajouter commentaire',
                          hintText: 'Commentaire',
                        ),
                        style: Theme.of(context).textTheme.labelLarge,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                    Visibility(
                      visible: !_hasPeriod,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 10,
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _showPaymentMontPicker(context);
                              },
                              child: const Text("Periode de payement"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paymentPeriod,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 10,
                        right: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showPaymentDatePicker(context);
                            },
                            child: const Text("Date de payement"),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            stringValueOfDate(_selectedPaymentDate),
                            style: const TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Card(
                elevation: 0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _imagesItems.length,
                  itemBuilder: (context, index) {
                    return _imagesItems[index];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      },
    );
  }

  Future<void> _showPaymentMontPicker(BuildContext context) async {
    showMonthPicker(
      context: context,
      initialDate: _selectedPeriodDate,
      firstDate: widget.occupant!.entryDate,
      // unselectedMonthTextColor: Colors.black,
    ).then(
      (date) => {
        if (date != null)
          {
            setState(() {
              _selectedPeriodDate = date;
            }),
          },
      },
    );
  }

  void _showPaymentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _selectedPaymentDate,
      firstDate: widget.occupant!.entryDate,
      lastDate: DateTime(2080),
    ).then(
      (date) => {
        if (date != null)
          {
            setState(() {
              _selectedPaymentDate = date;
              print(" Selected date: ${_selectedPaymentDate.month}");
            }),
          },
      },
    );
  }

  bool _checkValues() {
    if (_amountController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void _initPaymentPeriod() {
    if (widget.paymentPeriod != null) {
      _selectedPeriodDate = widget.paymentPeriod!;
      _hasPeriod = true;
    } else {
      _selectedPeriodDate = DateTime.now();
    }
  }

  void _onRemoveImage(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void _updateImageFromFiles() {
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

  Future<void> _addPayment(BuildContext context) async {
    showCircularProgressIndicatorDialog(context);

    if (!_checkValues()) {
      var message = 'Saisir le montant';

      showMessage(context, message);
      return;
    } else {
      double totalAmount = 0;
      var year = _selectedPeriodDate.year;
      var month = _selectedPeriodDate.month;
      var amount = double.parse(_amountController.text);

      List<Payment> payments = widget.occupant!.payments;
      var rent = widget.apartment.rent(year, month);

      for (Payment payment in payments) {
        if (payment.paymentPeriod.year == year &&
            payment.paymentPeriod.month == month) {
          totalAmount += payment.amount;
        }
      }
      var newValue = totalAmount + amount;

      if (newValue <= rent.value) {
        var paymentDate = _selectedPaymentDate;
        var periodOfPayment = Period(month: month, year: year);
        var desc = _descController.text;

        CollectionReference occupants = FirebaseFirestore.instance.collection(
          'occupants',
        );
        var paymentId =
            occupants.doc(widget.occupant!.id).collection("payments").doc().id;
        var hash = paymentId.hashCode;

        Payment payment = Payment(
          paymentId: paymentId,
          amount: amount,
          paymentDate: paymentDate,
          paymentPeriod: periodOfPayment,
          desc: desc,
        );

        if (_files.isNotEmpty) {
          FirebaseStorage storage = FirebaseStorage.instance;
          for (XFile xFile in _files) {
            var file = File(xFile.path);
            var imageName = "IMG${DateTime.now().hashCode}";

            var storageDirectory = getStorageName(
              widget.occupant!,
              periodOfPayment,
            );

            try {
              await storage
                  .ref()
                  .child("images/$storageDirectory/$hash/$imageName")
                  .putFile(file);
              payment.imagesNames.add(imageName);
            } on FirebaseException catch (error) {
              if (kDebugMode) {
                print(error);
              }
            }
          }
        }

        widget.occupant!.payments.add(payment);

        await occupants
            .doc(widget.occupant!.id)
            .update(widget.occupant!.toMap())
            .then((value) {
              showMessage(context, "Payement ajouté avec succès");
              Navigator.of(context).pop();
            })
            .onError((error, stackTrace) {
              showMessage(context, "Une erreur s'est produite");
            });
      } else {
        showMessage(context, " $totalAmount déjà payé pour ce mois.");
      }
    }
  }

  Future<void> _chooseImage(ImageSource imageSource) async {
    await _imagePicker.pickImage(source: imageSource).then((value) {
      if (value != null) {
        var name = basename(value.path);
        print(" image name $name");
        setState(() {
          _files.add(value);
        });
      }
    });
  }
}
