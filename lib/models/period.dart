import 'package:oga/models/payment.dart';

/// This class represent the period of payment.
class Period {
  final int month;
  final int year;
  List<Payment> payments = [];

  Period({required this.month, required this.year});

  Period.fromMap(Map<String, dynamic> map)
      : month = map['month'],
        year = map['year'],
        payments =
            List<Payment>.from(map['payments'].map((e) => Payment.fromMap(e)))
                .toList();

  @override
  String toString() {
    return month < 10 ? '0$month/$year' : '$month/$year';
  }

  String format() {
    return month < 10 ? '0$month$year' : '$month$year';
  }
}
