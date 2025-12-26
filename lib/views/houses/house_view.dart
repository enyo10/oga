import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/models/house.dart';
import 'package:oga/views/apartements/apartments.dart';
import 'package:oga/widgets/oga_glass_container.dart';
import 'package:oga/widgets/oga_scaffold.dart';

import '../../helper/oga_colors.dart';

class HouseView extends StatelessWidget {
  final House house;
  const HouseView({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return OgaScaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),

          child: Text(house.name),
        ),
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 30,
          color: OgaColors.myLightBlue.shade100,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: OgaColors.myLightBlue.shade100),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OgaGlassContainer(
              child: Center(
                child: Text(
                  "Liste des appartements",
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: OgaColors.myLightBlue.shade100,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HouseScreen(house: house),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            OgaGlassContainer(
              child: Center(
                child: Text(
                  "Informations sur la maison",
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: OgaColors.myLightBlue.shade100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
