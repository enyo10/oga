import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oga/auth/auth_gate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oga/views/repair/repair_provider.dart';
import 'package:oga/views/repair/repair_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'helper/oga_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /* runApp(const OgaApp());*/
  runApp(
    ChangeNotifierProvider(
      create: (context) => RepairProvider(RepairService()),
      child: const OgaApp(),
    ),
  );
}

class OgaApp extends StatelessWidget {
  const OgaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oga app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: OgaColors.myLightBlue.shade100),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}
