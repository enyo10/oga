import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oga/models/occupant.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/apartment.dart';
import 'models/house.dart';
import 'models/payment.dart';

Future<List<Occupant>> loadOccupants() async {
  List<Occupant> occupants = [];
  await FirebaseFirestore.instance.collection('occupants').get().then((value) {
    occupants = value.docs.map((e) => Occupant.fromMap(e.data())).toList();
  });
  return occupants;
}

Future<List<House>> loadHouses() async {
  var references = FirebaseFirestore.instance.collection('houses');
  List<House> houseList = [];
  await references.get().then((value) {
    houses = value.docs.map((e) => House.fromMap(e.data(), e.id)).toList();
  });
  return houseList;
}

Future<QuerySnapshot> _loaData(Apartment apartment) async {
  return await FirebaseFirestore.instance
      .collection('occupants')
      .where('apartmentId', isEqualTo: apartment.id)
      .get();
}

bool? _checkStatus(Apartment apartment, Occupant occupant) {
  var paymentDone = _getActualPeriodsPayment(occupant);
  var rentValue = apartment.getActualRent().value;
  if (paymentDone == 0) {
    return null;
  } else {
    return paymentDone >= rentValue;
  }
}

double _getActualPeriodsPayment(Occupant occupant) {
  var date = DateTime.now();
  var month = date.month;
  var year = date.year;
  List<Payment> list = [];
  for (var payment in occupant.payments) {
    if (payment.paymentPeriod.year == year &&
        payment.paymentPeriod.month == month) {
      list.add(payment);
    }
  }
  return list.fold(
      0.0, (previousValue, element) => previousValue + element.amount);
}

List<House> houses = [];
List<Occupant>occupants= [];
@pragma('vm:entry-point')

void messageSend() async {
  print("+++++++++++ Message send call ++++++++++");
  var date = DateTime.now();

  print("-------------- ${houses.length}----------");
  if(houses.isNotEmpty && occupants.isNotEmpty){
    for (House house in houses) {
      var apartments = house.apartments;
      for (Apartment apartment in apartments) {
        for (Occupant occupant in occupants) {
          if (occupant.apartmentId == apartment.id) {
            var paymentStatus = _checkStatus(apartment, occupant);
            if (paymentStatus == null) {
              _sendMessage(
                  occupant.phoneNumber,
                  "Votre loyer du ${date.month}/"
                      "${date.year} en souffrance, veillez "
                      "régler la situation s'il vous plait");
            }
          }
        }
      }
    }
  }

}

/*++++++++++++++++++++ SMS Handler°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*/

_getPermission() async => await [
      Permission.sms,
    ].request();

Future<bool> _isPermissionGranted() async =>
    await Permission.sms.status.isGranted;

_sendMessage(String phoneNumber, String message, {int? simSlot}) async {
  var result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  if (result == SmsStatus.sent) {
    print("Sent");
  } else {
    print("Failed");
  }
}

Future<bool?> get _supportCustomSim async =>
    await BackgroundSms.isSupportCustomSim;

_sendSMS(Occupant occupant, String message) async {
  if (await _isPermissionGranted()) {
    if ((await _supportCustomSim)!) {
      _sendMessage("0041786959914", message, simSlot: 1);
    } else {
      _sendMessage("0041786959914", message);
    }
  } else {
    _getPermission();
  }
}
