import 'package:flutter/material.dart';

import '../../../helper/oga_colors.dart';
import '../../../models/occupant.dart';
import '../../../models/rent_period.dart';

class ApartmentScreenHeader extends StatelessWidget {
  const ApartmentScreenHeader({
    super.key,
    required this.occupant,
    required this.rent,
  });

  final Occupant? occupant;
  final Rent rent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        //height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Text(
                    "Nom:  ",
                    style: TextStyle(fontSize: 24, color: OgaColors.myLightBlue.shade100),
                  ),
                  Text(
                    occupant?.firstname ?? "",
                    style:  TextStyle(fontSize: 24, color: OgaColors.lowContrastText),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Text(
                    "Prenom: ",
                    style: TextStyle(
                      fontSize: 20,color: OgaColors.myLightBlue.shade100
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      occupant?.lastname ?? "",
                      style:  TextStyle(
                        fontSize: 20, color: OgaColors.lowContrastText
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Loyer: ",
                    style: TextStyle(fontSize: 20,color: OgaColors.myLightBlue.shade100),
                  ),
                  Text(
                    '${rent.value} CFA',
                    style: TextStyle(fontSize: 20, color: OgaColors.lowContrastText),
                  )
                ],
              ),
        /*      Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Avance: ${occupant?.rentAdvance}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      "Caution: ${occupant?.deposit}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),*/

            ],
          ),
        ),
      ),
    );
  }
}
