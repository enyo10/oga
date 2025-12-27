import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/helper/oga_colors.dart';
import 'package:oga/models/house.dart';
import 'package:oga/views/houses/house_view.dart';
import 'package:oga/views/screens/data_list.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../widgets/oga_glass_container.dart';
import '../../widgets/oga_scaffold.dart';
import 'add_house.dart';

class HousesListView extends DataListScreen {
  const HousesListView({super.key, required super.collectionName});

  @override
  HousesListViewState createState() => HousesListViewState();
}

class HousesListViewState extends DataListScreenState<HousesListView> {
  static _getPermission() async => await [Permission.sms].request();

  static Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  @override
  void initState() {
    _getPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OgaScaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Maisons",
            style: TextStyle(fontSize: 30),
          ),
        ),
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 30,
          color: OgaColors.myLightBlue.shade100,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: OgaColors.myLightBlue.shade100),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder:
                      (context) => ProfileScreen(
                        appBar: AppBar(
                          title: const Text('User Profile'),
                          backgroundColor: Colors.transparent,
                        ),
                        actions: [
                          SignedOutAction((context) {
                            Navigator.of(context).pop();
                          }),
                        ],
                        children: [
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.asset('assets/oie_png.png'),
                            ),
                          ),
                        ],
                      ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return const AddHouse();
            },
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          );
        },
        tooltip: 'Add house to firebase',
        child: const Icon(Icons.add),
      ), // This trailing comma m,
      body: StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //FlutterNativeSplash.remove();

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontSize: 30),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading...", style: TextStyle(fontSize: 30)),
            );
          }
          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(" Has no data", style: TextStyle(fontSize: 30)),
            );
          }

          var housesList =
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                House house = House.fromMap(data, document.id);
                return house;
              }).toList();
          housesList.sort((a, b) => a.name.compareTo(b.name));

          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              children:
                  housesList
                      .map(
                        (house) => OgaGlassContainer(

                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HouseView(house: house),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Center(
                                child: Text(
                                  house.name,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 28,
                                    color: OgaColors.myLightBlue.shade100,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  house.desc,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: OgaColors.myLightBlue.shade100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          );
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
