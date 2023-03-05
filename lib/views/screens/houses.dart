import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/helper/oga_colors.dart';
import 'package:oga/models/house.dart';
import 'package:oga/views/screens/data_list.dart';
import 'package:oga/views/screens/apartments.dart';
import 'package:oga/views/widgets/add_house.dart';

class Houses extends DataListScreen {
  const Houses({super.key, required super.collectionName});

  @override
  HousesState createState() => HousesState();
}

class HousesState extends DataListScreenState<Houses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("Les maisons"),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle:
            GoogleFonts.montserrat(fontSize: 30, color: Colors.purple),
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

          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                var id = document.id;
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                print("Data ----${data.toString()}");
                House house = House.fromMap(data, document.id);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 8,
                  color: house.backgroundColor,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "🏘  ${house.name}",
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
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
