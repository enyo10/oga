// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJRT5zZzQa07Jhh5fzjcxnmaycAqKPyqo',
    appId: '1:308192654251:web:7168dc63496f542b10d8ee',
    messagingSenderId: '308192654251',
    projectId: 'oga-roan',
    authDomain: 'oga-roan.firebaseapp.com',
    storageBucket: 'oga-roan.appspot.com',
    measurementId: 'G-0HB0RV149B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD3cmnqLaVfGis6KxCWf_YE5TVmwLuA-o',
    appId: '1:308192654251:android:a360d9f18147687b10d8ee',
    messagingSenderId: '308192654251',
    projectId: 'oga-roan',
    storageBucket: 'oga-roan.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGWweewJDA_DCM0XgGJnuQk0rZuzGVd9k',
    appId: '1:308192654251:ios:115866a4be11894310d8ee',
    messagingSenderId: '308192654251',
    projectId: 'oga-roan',
    storageBucket: 'oga-roan.appspot.com',
    iosClientId: '308192654251-njubnokpkf1d2mul5jah7rofq4r8badm.apps.googleusercontent.com',
    iosBundleId: 'com.example.oga',
  );
}
