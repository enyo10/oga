import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oga/models/occupant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'models/apartment.dart';
import 'models/house.dart';
import 'models/payment.dart';

class Messaging {
  static List<Occupant> occupants = [];
  static List<House> houses = [];
  static Map<String, dynamic> params = {};

  static Future<void> initialize(String id) async {
    houses = await loadHouses(id);
    for(House h in houses){
      print(h.toString());
    }

    print(houses.toString());
    occupants = await loadOccupants();

    params = {
      'houses': houses.map((e) => e.toMap()).toList(),
      'occupants': occupants.map((e) => e.toMap()).toList()
    };
  }

  static Future<List<Occupant>> loadOccupants() async {
    var reference =
        await FirebaseFirestore.instance.collection('occupants').get();
    return reference.docs.map((e) => Occupant.fromMap(e.data())).toList();
  }

  static Future<List<House>> loadHouses(String id) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('houses')
        .where('uid', isEqualTo: id)
        .get();

    return querySnapshot.docs
        .map((e) => House.fromMap(e.data(), e.id))
        .toList();
  }

  static bool? checkStatus(Apartment apartment, Occupant occupant) {
    var paymentDone = _getActualPeriodsPayment(occupant);
    var rentValue = apartment.getActualRent().value;
    if (paymentDone == 0) {
      return null;
    } else {
      return paymentDone >= rentValue;
    }
  }

  static double _getActualPeriodsPayment(Occupant occupant) {
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

  @pragma('vm:entry-point')
  static void callback(int id, Map<String, dynamic> params) async {
    print("+++++++++++ Message send call ++++++++++");
    List<House> houses =
        List<House>.from(params['houses'].map((e) => House.fromMap(e, "")))
            .toList();
    List<Occupant> occupants =
        List<Occupant>.from(params['occupants'].map((e) => Occupant.fromMap(e)))
            .toList();
    var date = DateTime.now();
    var year = params['year'];

    print("-------------  ${houses.length}   ----------");
    if (houses.isNotEmpty && occupants.isNotEmpty) {
      for (House house in houses) {
        var apartments = house.apartments;
        for (Apartment apartment in apartments) {
          for (Occupant occupant in occupants) {
            if (occupant.apartmentId == apartment.id) {
              var paymentStatus = checkStatus(apartment, occupant);
              if (paymentStatus == null) {
                  _sendMessage(
                    occupant.phoneNumber,
                    "Votre loyer du ${date.month}/"
                    "${date.year} en souffrance, veillez "
                    "régler la situation s'il vous plait");
              }
              if (paymentStatus == false) {

                  _sendMessage(
                    occupant.phoneNumber,
                    "Votre loyer du ${date.month}/"
                    "${date.year}  vous n'avez pas encore payé la totalité."
                    "Nous vous prions de le régler.  ");

              }
            }
          }
        }
      }
    }
  }

/*++++++++++++++++++++ SMS Handler°°°°°°°°°°°°°°°°°°°°°°°°°°°°°*/

 /* static _getPermission() async => await [
        Permission.sms,
      ].request();

  static Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;
*/
  static _sendMessage(String phoneNumber, String message,
      {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }

  static Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;

  /*_sendSMS(Occupant occupant, String message) async {
    if (await _isPermissionGranted()) {
      if ((await _supportCustomSim)!) {
        _sendMessage("0041786959914", message, simSlot: 1);
      } else {
        _sendMessage("0041786959914", message);
      }
    } else {
      _getPermission();
    }
  }*/
}
