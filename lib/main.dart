import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/messaging.dart';
import 'auth/auth_gate.dart';
import 'firebase_options.dart';
import 'helper/oga_colors.dart';

/*
@pragma('vm:entry-point')
void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
}
*/

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//  houses = await loadHouses();
 // occupants =  await loadOccupants();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oga',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xEEE1F5FE),
          primarySwatch: OgaColors.myLightBlue,
          primaryColor: Colors.blue[100]),
      home: const AuthGate(),
    );
  }
}
