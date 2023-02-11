import 'package:flutter/material.dart';

import '../../models/occupant.dart';
import '../../models/rent_period.dart';

class ApartmentScreenHeader extends StatelessWidget {
  const ApartmentScreenHeader({
    Key? key,
    required this.occupant,
    required this.rent,
  }) : super(key: key);

  final Occupant? occupant;
  final Rent rent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // color: const Color(0xFFE3F2FD),
     // color: const Color(0xeee1f5fe),
      child: SizedBox(
        //height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Nom:  ",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        occupant?.firstname ?? "",
                        style: const TextStyle(fontSize: 24),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Prenom: ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          occupant?.lastname ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Caution: ${occupant?.rentAdvance}",
                        style: const TextStyle(fontSize: 20), ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Avance: ${occupant?.deposit}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Loyer: ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${rent.value} CFA',
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
