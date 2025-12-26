import 'package:flutter/material.dart';

import '../../../helper/helper.dart';
import '../../../models/occupant.dart';
import '../../../models/payment.dart';
import 'payment_details.dart';

class PaymentListTile extends StatefulWidget {
  const PaymentListTile({
    super.key,
    required this.payment,
    this.color,
    required this.occupant,
  });

  final Payment payment;
  final Occupant occupant;

  final Color? color;

  @override
  State<PaymentListTile> createState() => _PaymentListTileState();
}

class _PaymentListTileState extends State<PaymentListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Payment payment = widget.payment;
    var amount = "${payment.amount} CFA";
    var period = payment.paymentPeriod.toString();
    var date = stringValueOfDate(payment.paymentDate);
    var info = (widget.payment.desc == '') ? " " : "i";

    return GestureDetector(
      onDoubleTap: () async {
        await Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => PaymentDetails(
                  payment: payment,
                  occupant: widget.occupant,
                ),
              ),
            )
            .then((value) => setState(() {}));
      },
      child:
          PaymentCard(period: period, amount: amount, date: date, info: info),
    );
  }

  /* Widget _paymentWidget(Payment payment) {
    var info = (payment.desc == '') ? " " : "i";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyTextWidget(
            text: payment.paymentPeriod.toString(),
          ),
          MyTextWidget(text: "${payment.amount} ${payment.currency}"),
          MyTextWidget(text: payment.rate.toString()),
          MyTextWidget(text: stringValue(payment.paymentDate)),
          MyTextWidget(text: info),
        ],
      ),
    );
  }*/
}

class PaymentTileHeader extends StatelessWidget {
  const PaymentTileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var period = 'Periode';
    var amount = "Montant";
    var date = "Date de paie";
    var info = "";

    return Card(
      color: Colors.white70,
      //semanticContainer: false,
      shadowColor: Colors.green,
      elevation: 8.0,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyTextWidget(text: period),
            MyTextWidget(text: amount),
            MyTextWidget(text: date),
            const Text("")


            // MyTextWidget(text: info)
          ],
        ),
      ),
    );
  }
}

class TotalAmountWidget extends StatelessWidget {
  final double amount;
  final double height;

  const TotalAmountWidget(
      {super.key, required this.amount, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        color: Colors.white70,
        //semanticContainer: false,
        semanticContainer: true,
        shadowColor: Colors.green,
        elevation: 10.0,
        /*shape: OutlineInputBorder(*/
        /*    borderRadius: BorderRadius.circular(10),*/
        /*    borderSide: const BorderSide(color: Colors.white))*/
        child: ListTile(
          /* contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),*/
          textColor: Colors.black,
          title: Text("  Montant total :   $amount"),
        ),
      ),
    );
  }
}

class MyTextWidget extends StatelessWidget {
  final String text;

  const MyTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MyRow extends StatelessWidget {
  const MyRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard(
      {super.key,
      this.color,
      required this.period,
      required this.amount,
      //  required this.tax,
      required this.date,
      required this.info});
  final Color? color;
  final String period;
  final String amount;
  // final String tax;
  final String date;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.green,
      elevation: 4.0,
      child: ListTile(
        trailing: SizedBox(
          width: 10,
          child: Text(
            info,
            style: const TextStyle(
                color: Colors.amber, fontStyle: FontStyle.italic, fontSize: 25),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(period),
            Text(
              amount,
              style: _isNegative()
                  ? const TextStyle(color: Colors.redAccent)
                  : const TextStyle(),
            ),
            //   Text(tax),
            Text(date)
          ],
        ),
      ),
    );
  }

  bool _isNegative() => amount.contains("-");
}
