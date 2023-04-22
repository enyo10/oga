import 'dart:convert';

import 'package:oga/models/period.dart';

class Payment {
  final String paymentId;
  final double amount;
  final DateTime paymentDate;
  final Period paymentPeriod;
  String desc;
  List<dynamic> imagesNames = [];

  Payment(
      {required this.paymentId,
      required this.amount,
      required this.paymentDate,
      required this.paymentPeriod,
      required this.desc});

  Payment.fromMap(Map<String, dynamic> map)
      : paymentId = map['id'],
        paymentDate = DateTime.parse(map['paymentDate']),
        paymentPeriod = Period(
            month: map['paymentPeriod']['month'],
            year: map['paymentPeriod']['year']),
        amount = map['amount']+.0,
        desc = map['desc'] ?? '',
        imagesNames = jsonDecode(map['imagesNames'])
            .toList();

  Map<String, dynamic> toMap() {
    return {
      "id": paymentId,
      "paymentDate": paymentDate.toIso8601String(),
      "amount": amount,
      "desc": desc,
      "imagesNames":jsonEncode(imagesNames),
      "paymentPeriod": {
        "month": paymentPeriod.month,
        "year": paymentPeriod.year,

      },
    };
  }

  String stringValue() {
    return '${paymentPeriod.toString()},';
  }

  @override
  String toString() {
    return 'Payment{paymentId: $paymentId, amount: $amount, paymentDate: $paymentDate, paymentPeriod: $paymentPeriod,}';
  }
}
