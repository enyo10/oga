import 'dart:convert';

import 'package:oga/models/payment.dart';

class Occupant {
  final String id;
  final String apartmentId;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String email;
  final DateTime entryDate;
  DateTime? releaseDate;
  List<Payment> payments = [];
  double deposit;
  double rentAdvance;
  List<dynamic> docsNames = [];
  String rentalAgreement;

  Occupant(
      {required this.id,
      required this.apartmentId,
      required this.firstname,
      required this.lastname,
      required this.phoneNumber,
      required this.email,
      required this.entryDate,
      required this.deposit,
      required this.rentAdvance,
      required this.rentalAgreement});

  void terminateLease(int year, int month) {
    releaseDate = DateTime(year = year, month = month);
  }

  void addPayment(Payment payment) {
    payments.add(payment);
  }

  void modifyDeposit(double amount) {
    if (deposit >= amount) {
      deposit += amount;
    }
  }

  void modifyAdvanceRent(double amount) {
    if (rentAdvance >= amount) {
      rentAdvance += amount;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apartmentId': apartmentId,
      'firstname': firstname,
      'lastname': lastname,
      'phoneNumber': phoneNumber,
      'email': email,
      'payments': payments.map((payment) => payment.toMap()).toList(),
      'deposit': deposit,
      'advanceRent': rentAdvance,
      'entryDate': entryDate.toIso8601String(),
      'releaseDate': releaseDate?.toIso8601String(),
      'docsNames': jsonEncode(docsNames),
      'rentalAgreement': rentalAgreement,
    };
  }

  Occupant.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        apartmentId = map['apartmentId'],
        firstname = map['firstname'],
        lastname = map['lastname'],
        phoneNumber = map['phoneNumber'],
        email = map['email'],
        deposit = double.parse(map['deposit'].toString()),
        rentAdvance = double.parse(map['advanceRent'].toString()),
        payments =
            List<Payment>.from(map['payments'].map((e) => Payment.fromMap(e)))
                .toList(),
        entryDate = DateTime.parse(map['entryDate']),
        releaseDate = map['releaseDate'] != null
            ? DateTime.parse(map['releaseDate'])
            : null,
        rentalAgreement = map['rentalAgreement'],
        docsNames = jsonDecode(map['docsNames']).toList();
}
