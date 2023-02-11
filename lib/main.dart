import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:oga/authentication/home_view.dart';
import 'package:oga/authentication/login_view.dart';
import 'package:oga/helper/helper.dart';
import 'package:oga/views/screens/houses.dart';
import 'auth/auth_gate.dart';
import 'authentication/sign_up_view.dart';
import 'firebase_options.dart';
import 'helper/palette_colors.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
          // backgroundColor: const Color(0xeee1f5fe),
          scaffoldBackgroundColor: const Color(0xEEE1F5FE),
          primarySwatch: Palette1.myLightBlue,
          primaryColor: Colors.blue[900]),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),

      // home: const Houses(collectionName: kHouseCollection),
      home: const AuthGate(),
    );
  }
}
