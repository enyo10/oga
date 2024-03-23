import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/models/apartment.dart';

import '../../../helper/helper.dart';
import '../../../models/occupant.dart';
import '../../../models/payment.dart';
import '../payments/add_payment.dart';
import '../payments/payment_list_tile.dart';

class PeriodPayments extends StatefulWidget {
  final List<Payment> payments;
  final Occupant occupant;
  final Apartment apartment;
  final Data data;
  final int actualYear;

  const PeriodPayments({
    super.key,
    required this.payments,
    required this.occupant,
    required this.apartment,
    required this.data,
    required this.actualYear,
  });

  @override
  State<PeriodPayments> createState() => _PeriodPaymentsState();
}

class _PeriodPaymentsState extends State<PeriodPayments> {
  late List<Payment> payments;
  double totalAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (kDebugMode) {
      print(" Date is before entry date : ${_requiredPayment()} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    //int year = DateTime.now().year;
    //  int year = widget.actualYear;
    var monthInt = widget.data.month;
    var month = monthMap[monthInt];
    var rent = widget.apartment.rent(widget.actualYear, monthInt).value;
    double height = MediaQuery.of(context).size.height * 0.10;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$month : $rent CFA",
          style: GoogleFonts.charmonman(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !_isBalanced(),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => AddPayment(
                  occupant: widget.occupant,
                  paymentPeriod: DateTime(
                    widget.actualYear,
                    widget.data.month,
                  ),
                  apartment: widget.apartment,
                ),
                fullscreenDialog: false,
              ),
            )
                .then((value) {
              print(" payment length ${value.payments.length}");
              _loadData();
            }).onError((error, stackTrace) => null);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: height + 10),
        child: _isLoading
            ? Center(
                child: Text(
                  "...En chargement",
                  style: GoogleFonts.charmonman(fontSize: 40),
                ),
              )
            : Column(
                children: [
                  const PaymentTileHeader(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (_, index) {
                        var payment = payments.elementAt(index);
                        return PaymentListTile(
                          payment: payment,
                          occupant: widget.occupant,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomSheet: TotalAmountWidget(
        amount: totalAmount,
        height: height,
      ),
    );
  }

  Future<void> _loadData() async {
    var month = widget.data.month;
    // var year = DateTime.now().year;
    var year = widget.actualYear;
    List<Payment> list = [];
    for (var payment in widget.occupant.payments) {
      if (payment.paymentPeriod.year == year &&
          payment.paymentPeriod.month == month) {
        list.add(payment);
      }
    }
    setState(() {
      payments = list;
      totalAmount = getTotalAmount(payments);
      _isLoading = false;
    });
  }

  bool _isBalanced() {
    if (!_requiredPayment()) {
      return true;
    }
    return totalAmount >=
        widget.apartment.rent(DateTime.now().year, widget.data.month).value;
  }

  /// This method to check if the occupant have to pay for that period.
  bool _requiredPayment() {
    var date = DateTime(DateTime.now().year, widget.data.month);
    var entryDate = widget.occupant.entryDate;
    if (date.year == entryDate.year && date.month == entryDate.month) {
      return true;
    }

    return date.isAfter(entryDate);
  }
}
