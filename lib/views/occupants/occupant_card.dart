import 'package:flutter/material.dart';
import 'package:oga/helper/helper.dart';

import '../../../helper/oga_colors.dart';
import '../../../models/occupant.dart';

class OccupantCard extends StatelessWidget {
  final Occupant occupant;
  const OccupantCard({super.key, required this.occupant});

  @override
  Widget build(BuildContext context) {
    var entryDate = stringValueOfDate(occupant.entryDate);
   var releaseDate = occupant.releaseDate ==null?"":stringValueOfDate(occupant.releaseDate!);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(occupant.firstname, style: TextStyle(color: OgaColors.grey1),),
                  const SizedBox(width: 10,),
                  Text(occupant.lastname),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text("Date d'entrée: $entryDate}"),

              ],),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text("Date de résiliaion: $releaseDate")
              ],),
            )
          ],
        ),
      ),
    );
  }
}
