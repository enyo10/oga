import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oga/helper/oga_colors.dart';
import 'package:oga/models/apartment.dart';
import 'package:oga/models/occupant.dart';
import 'package:oga/views/screens/periods/period_payments.dart';
import 'package:oga/views/screens/occupants/add_occupant.dart';
import 'package:oga/views/screens/payments/add_payment.dart';

import '../../../helper/helper.dart';
import '../../../models/house.dart';
import '../../../models/payment.dart';
import '../../../models/rent_period.dart';
import 'apartement_screen_header.dart';
import '../../widgets/number_picker.dart';
import '../../widgets/oga_scaffold.dart';
import '../occupants/occupants.dart';
import '../occupants/occupant_details.dart';

class ApartmentScreen extends StatefulWidget {
  const ApartmentScreen(
      {Key? key, required this.apartment, required this.house, this.year})
      : super(key: key);
  final Apartment apartment;
  final House house;
  final int? year;

  @override
  State<ApartmentScreen> createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {
  CollectionReference occupants =
      FirebaseFirestore.instance.collection('occupants');
  static late List<Data> monthDataList;
  static Occupant? _occupant;
  static late int _year;
  DateTime? leaseDate;
  late String? occupantId;
  static String occupantTelNumber = "";
  static late Apartment apartment;
  static late Map<String, dynamic> map;

  @override
  void initState() {
    super.initState();
    occupantId = widget.apartment.occupantId;
    apartment = widget.apartment;
    if (widget.year == null) {
      _year = DateTime.now().year;
    }
    _initMonthList();
    _loadPayments();
    map = {
      'monthDataList': monthDataList.map((e) => e.toMap()).toList(),
      'apartment': apartment.toMap(),
      'year': _year
    };
    /*const int helloAlarmID = 33;

    AndroidAlarmManager.periodic(
        const Duration(minutes: 1), helloAlarmID, callBack,
        params: map);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Rent rent = widget.apartment.getActualRent();

    return SafeArea(
      child: OgaScaffold(
        appBar: occupantId == null
            ? AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: OgaColors.blueButton,
                  ),
                ),
              )
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: OgaColors.blueButton,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _search();
                    },
                    icon: Icon(
                      Icons.search,
                      color: OgaColors.blueButton,
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      textTheme:
                          const TextTheme().apply(bodyColor: Colors.black),
                      dividerColor: Colors.white,
                      iconTheme: IconThemeData(color: OgaColors.blueButton),
                    ),
                    child: PopupMenuButton<int>(
                      color: OgaColors.replaceBackgroundBlurBlack,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(value: 0, child: Text(_itemValue)),
                        const PopupMenuItem<int>(
                            value: 1, child: Text("Liste des paiements")),
                        const PopupMenuDivider(),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.date_range,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text("Year")
                            ],
                          ),
                        ),
                      ],
                      onSelected: (item) => _selectedItem(context, item),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _isApartmentOccupied()
                ? await _addPayment(
                    widget.apartment,
                    _occupant!,
                  ).then((value) => setState(() {}))
                : await showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return AddOccupant(
                        apartment: widget.apartment,
                        house: widget.house,
                      );
                    },
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ).then(
                    (value) => setState(() {
                      _occupant = value;
                    }),
                  );
          },
          child: Icon(
            Icons.add,
            color: OgaColors.greyText10,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: occupants.doc(widget.apartment.occupantId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Card(
                      color: Colors.amberAccent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Nom:  ",
                                  style: TextStyle(fontSize: 24),
                                ),
                                Text(
                                  "",
                                  style: TextStyle(fontSize: 24),
                                )
                              ],
                            ),
                            Row(
                              children: const [Text("Prenom: "), Text("")],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Loyer: ",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Text(
                                  "${rent.value}",
                                  style: const TextStyle(fontSize: 30),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Card(
                        child: Center(
                          child: Text("Something went wrong"),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                _occupant = null;
                return Column(
                  children: [
                    ApartmentScreenHeader(occupant: _occupant, rent: rent),
                    const Expanded(
                      child: Card(
                        child: Center(
                          child: Text(
                            "Appartement vide",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                _occupant = Occupant.fromMap(data);
                occupantTelNumber = _occupant!.phoneNumber;

                _loadPayments();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      GestureDetector(
                        onDoubleTap: () async {
                          _navigateToOccupantDetails();
                        },
                        child: ApartmentScreenHeader(
                          occupant: _occupant,
                          rent: rent,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Situation en $_year",
                              style: TextStyle(
                                  fontSize: 20, color: OgaColors.blueButton),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: monthDataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _monthDataWidget(index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: Text("loading"));
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<void> _navigateToOccupantDetails() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            OccupantDetails(occupant: _occupant!),
      ),
    );
  }

  /* Future<void> _showRemoveOccupantDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ATTENTION',
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le locataire quitte vraiment son logement?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Continuer'),
              onPressed: () async {
                if (!mounted) return;
                Navigator.of(context).pop();
                await _removeOccupantView();
              },
            ),
          ],
        );
      },
    );
  }*/

/*
  Future<void> _removeOccupantView() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return LeaseApartmentWidget(
            occupant: _occupant!,
            house: widget.house,
            apartment: widget.apartment);
      },
      backgroundColor: Colors.redAccent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0),
        ),
      ),
    );
  }
*/

  void _initMonthList() {
    List<Data> list = [];
    for (var i = 1; i <= 12; i++) {
      list.add(Data(month: i));
    }
    monthDataList = list;
  }

  void _loadPayments() async {
    List<Payment> paymentList = [];
    _initMonthList();

    if (_occupant != null) {
      for (var payment in _occupant!.payments) {
        if (payment.paymentPeriod.year == _year) {
          paymentList.add(payment);
        }
      }

      for (var i = 0; i < monthDataList.length; i++) {
        for (var j = 0; j < paymentList.length; j++) {
          if (monthDataList.elementAt(i).month ==
                  paymentList.elementAt(j).paymentPeriod.month &&
              _year == paymentList.elementAt(j).paymentPeriod.year) {
            monthDataList.elementAt(i).addPayment(paymentList.elementAt(j));
          }
        }
      }
    }
  }

  @pragma('vm:entry-point')
  /* static void callback() {
    var date = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print(" Current Isole $isolateId");

    print(
        "Paiement en souffrence. Veuiller régler la situation s'il vous plait");
    */ /* var index = date.month;
    var data = monthDataList.elementAt(index - 1);
    var rent = _getActualRent(data.month);
    List<Payment> payments = data.payments;
    var sum = _getSum(payments);

    if (sum < rent.value) {
      print(
          "Paiement en souffrence. Veuiller régler la situation s'il vous plait");
    }else{
      print(" Tu es à jour ---------");
    }*/ /*
  }*/

  Widget _monthDataWidget(int index) {
    var data = monthDataList.elementAt(index);
    var month = monthMap[data.month];

    List<Payment> payments = data.payments;
    var icon = _paymentsStatus(payments, month!, index);
    return GestureDetector(
      onDoubleTap: () async {
        await _navigateToPeriodsPayments(payments, data);
        setState(() {});
      },
      child: SizedBox(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 150.0,
                  child: Text(
                    month,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                Visibility(
                  visible: _isVisible(index, payments),
                  child: icon,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isVisible(int index, List<Payment> payments) {
    var actualYear = DateTime.now();
    var actualMonth = actualYear.month;

    if (_year < actualYear.year) {
      return true;
    }

    if (index < actualMonth || payments.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool _isPeriodOK(int index, List<Payment> payments) {
    var actualYear = DateTime.now();
    var actualMonth = actualYear.month;

    if (_year < actualYear.year) {
      return true;
    }

    if (index < actualMonth || payments.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool _isApartmentOccupied() {
    return _occupant != null;
  }

  Icon _paymentsStatus(List<Payment> paymentList, String month, int index) {
    var payments = paymentList;

    var icon = const Icon(
      Icons.close,
      color: Colors.red,
    );

    if (payments.isNotEmpty) {
      var month = payments.first.paymentPeriod.month;
      var rent = _getActualRent(month);
      var sum = _getSum(payments);

      if (sum == rent.value) {
        icon = const Icon(
          Icons.check,
          color: Colors.green,
        );
      } else {
        if (_isPeriodOK(index, payments)) {
          print(" Veuillez soldez votre compte pour $month");
        }
        icon = const Icon(
          Icons.check_box_outlined,
          color: Colors.orange,
        );
      }
    } else {
      if (_isPeriodOK(index, payments)) {
        print("Paiement de $month en souffrance\n"
            "Veuillez regler au plus vite."
            "  "
            "$occupantTelNumber");
      }
    }

    return icon;
  }

  double _getSum(List<Payment> payments) {
    var sum = 0.0;

    for (Payment payment in payments) {
      sum += payment.amount;
    }
    return sum;
  }

  Rent _getActualRent(int month) {
    return widget.apartment.rent(_year, month);
  }

  Future<void> _addPayment(Apartment apartment, Occupant? occupant) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPayment(
          occupant: occupant,
          apartment: apartment,
        ),
      ),
    );
  }

  Future<void> _navigateToPeriodsPayments(
      List<Payment> payments, Data data) async {
    var periodPayments = PeriodPayments(
      payments: payments,
      occupant: _occupant!,
      apartment: widget.apartment,
      data: data,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => periodPayments),
    );
  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Occupants(
          apartmentId: widget.apartment.id,
        ),
      ),
    );
  }

  Future<void> _selectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        await showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return AddOccupant(
              apartment: widget.apartment,
              house: widget.house,
              occupant: _occupant,
            );
          },
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ).then(
          (value) => setState(
            () {
              _occupant = value;
            },
          ),
        );

        /* _isOccupied()
            ? await _addPayment(
                widget.apartment,
                _occupant!,
              ).then((value) => setState(() {}))
            : await showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return AddOccupant(
                    apartment: widget.apartment,
                    house: widget.house,
                  );
                },
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ).then((value) => setState(() {
                  _occupant = value;
                }));
       */
        break;

      case 1:
        /* if (_isOccupied()) {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => PaymentsList(occupant: _occupant!),
            ),
          )
              .then((value) => _loadOccupantWithPayment());
        }*/
        break;
      case 2:
        _selectYear();
        break;
    }
  }

  String get _itemValue =>
      _isApartmentOccupied() ? "Résilier bail " : "Ajouter locataire";

  Future<void> _selectYear() async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
            height: 400,
            child: PickedNumber(
              currentValue: _year,
              minValue: _occupant!.entryDate.year,
            ));
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _year = value;
          _loadPayments();
        });
      }
    });
  }

  @pragma('vm:entry-point')
  static void printHelloBis() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print(
        "[$now] Hello, Roger! isolate=${isolateId} function='$printHelloBis'");
  }
}

/*void callBack(int id, Map<String, dynamic> params) {
  DateTime actualDate = DateTime.now();
  print("++++++++++++   callback called  ++++++++++++");
  var apartment = Apartment.fromMap(params['apartment']);
  print('++++++++++++  ${apartment.id}       ++++++++++++++++++');
  List<Data> monthDataList =
      List<Data>.from(params['monthDataList']!.map((e) => Data.fromMap(e)))
          .toList();
  print("-----------   ${monthDataList.length} -------------------------");

  var year = params['year'];

  for (int i = 0; i < monthDataList.length; i++) {
    Data monthData = monthDataList[i];
    Rent rent = apartment.rent(year, i + 1);
    List<Payment> payments = monthData.payments;
    var sum = payments.fold(
        0.0, (previousValue, element) => previousValue + element.amount);
    apartment.rent(1, 2);
    if (sum < rent.value) {
      print("++++++++++   Vous nous devez de l'argent   *****************");
    }
  }
}*/
