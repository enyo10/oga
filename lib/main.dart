import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/auth_gate.dart';
import 'firebase_options.dart';
import 'helper/oga_colors.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        //  scaffoldBackgroundColor: Colors.white,

        primarySwatch: OgaColors.myLightBlue,
        primaryColor: Colors.blue[900],
      ),
      home: const AuthGate(),
    );
  }
}
