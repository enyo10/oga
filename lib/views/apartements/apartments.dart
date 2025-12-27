import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../helper/oga_colors.dart';
import '../../../helper/oga_style.dart';
import '../../../models/house.dart';
import '../../../models/occupant.dart';
import '../../widgets/oga_glass_container.dart';
import '../../widgets/oga_scaffold.dart';
import 'add_apartment.dart';
import 'apartment_screen.dart';

class HouseScreen extends StatefulWidget {
  const HouseScreen({super.key, required this.house});
  final House house;

  @override
  State<HouseScreen> createState() => _HouseScreenState();
}

class _HouseScreenState extends State<HouseScreen> {
  late House _house;
  List<Occupant> _occupants = [];
  @override
  void initState() {
    _house = widget.house;
    _loadOccupants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var count = _house.apartments.length;

    return OgaScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: appBarTitleTextStyle,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: OgaColors.myLightBlue.shade100),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            _house.name,
            style: TextStyle(color: OgaColors.myLightBlue.shade100),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return AddApartment(house: _house);
            },
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 40),
        child:
            count == 0
                ? Center(
                  child: Text(
                    " Pas de donnée",
                    style: TextStyle(fontSize: 30, color: OgaColors.whiteText1),
                  ),
                )
                : ListView.builder(
                  itemCount: widget.house.apartments.length,
                  itemBuilder: (BuildContext context, int index) {
                    var apartment = widget.house.apartments[index];
                    Occupant? occupant;

                    for (Occupant o in _occupants) {
                      if (o.id == apartment.occupantId) {
                        occupant = o;
                      }
                    }

                    return OgaGlassContainer(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (builder) => ApartmentScreen(
                                  house: widget.house,
                                  apartment: apartment,
                                ),
                          ),
                        );
                        setState(() {});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "🏠  ${apartment.name}",
                              style: GoogleFonts.montserrat(
                                fontSize: 40,
                                color: OgaColors.myLightBlue.shade100,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Locataire:",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,
                                    color: OgaColors.myLightBlue.shade100,
                                  ),
                                ),
                              ),
                              Text(
                                occupant?.firstname ?? "",
                                style: GoogleFonts.montserrat(
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  color: OgaColors.myLightBlue.shade100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /*
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Center(
                        child: ListTile(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (builder) => ApartmentScreen(
                                    house: widget.house, apartment: apartment),
                              ),
                            );
                            setState(() {});
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "🏠  ${apartment.name}",
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Locataire:",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              Text(occupant?.firstname ?? ""),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return AddApartment(
                                    house: _house,
                                    apartment: apartment,
                                  );
                                },
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ).then((value) => setState(() {}));
                            },
                            icon: const Icon(
                              Icons.update,
                              size: 40,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),*/
                    );
                  },
                ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> _loadOccupants() async {
    CollectionReference occupants = FirebaseFirestore.instance.collection(
      'occupants',
    );

    await occupants.get().then((value) {
      _occupants =
          value.docs
              .map((e) => Occupant.fromMap(e.data() as Map<String, dynamic>))
              .toList();
    });
    setState(() {});
  }
}
