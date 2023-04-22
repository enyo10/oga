import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/helper/oga_colors.dart';
import 'package:oga/messaging.dart';
import 'package:oga/models/house.dart';
import 'package:oga/views/screens/data_list.dart';
import 'package:oga/views/screens/apartements/apartments.dart';
import 'package:oga/views/screens/houses/add_house.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/oga_scaffold.dart';

class Houses extends DataListScreen {
  const Houses({super.key, required super.collectionName});

  @override
  HousesState createState() => HousesState();
}

class HousesState extends DataListScreenState<Houses> {
  //String uId = FirebaseAuth.instance.currentUser!.uid;
  static _getPermission() async => await [
    Permission.sms,
  ].request();

  static Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  @override
  void initState() {
    _getPermission();

    Messaging.initialize(userId).then((value) {
      var params = Messaging.params;
      print(" llllllll lllll maisons  ${Messaging.houses.length}");
      const int helloAlarmID = 21;
      AndroidAlarmManager.periodic(
        const Duration(minutes: 1),
        helloAlarmID,
        Messaging.callback,
        params: params,
      );
    });

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
            //style: TextStyle(color: OgaColors.grey2),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 30,
          color: OgaColors.blueButton,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: OgaColors.blueButton,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
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
          )
        ],
        automaticallyImplyLeading: false,
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
          FlutterNativeSplash.remove();

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
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 30),
              ),
            );
          }
          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                " Has no data",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            );
          }

          var housesList = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            House house = House.fromMap(data, document.id);
            return house;
          }).toList();
          housesList.sort((a, b) => a.name.compareTo(b.name));

          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              children: housesList
                  .map((house) => Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 8,
                        color: house.backgroundColor,
                        child: ListTile(
                          leading: Container(
                            //  color: Colors.white,
                            child: const Text('🏘',
                                style: TextStyle(fontSize: 40)),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              " ${house.name}",
                              style: const TextStyle(fontSize: 24),
                              maxLines: 1,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: AutoSizeText(
                                house.desc,
                                style: const TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HouseScreen(
                                  house: house,
                                ),
                              ),
                            );
                          },
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
