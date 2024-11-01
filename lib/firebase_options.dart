// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['GOOGLE_WINDOWS_API_KEY'] ?? "",
    appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
    messagingSenderId: '332259428605',
    projectId: 'quotemasterpushnoti',
    authDomain: 'quotemasterpushnoti.firebaseapp.com',
    storageBucket: 'quotemasterpushnoti.appspot.com',
    measurementId: 'G-14X4R86G5J',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['GOOGLE_ANDROID_API_KEY'] ?? "",
    appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
    messagingSenderId: '332259428605',
    projectId: 'quotemasterpushnoti',
    storageBucket: 'quotemasterpushnoti.appspot.com',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['GOOGLE_IOS_API_KEY'] ?? "",
    appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
    messagingSenderId: '332259428605',
    projectId: 'quotemasterpushnoti',
    storageBucket: 'quotemasterpushnoti.appspot.com',
    iosBundleId: 'com.example.flutterQuoteMaster',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['GOOGLE_IOS_API_KEY'] ?? "",
    appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
    messagingSenderId: '332259428605',
    projectId: 'quotemasterpushnoti',
    storageBucket: 'quotemasterpushnoti.appspot.com',
    iosBundleId: 'com.example.flutterQuoteMaster',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['GOOGLE_WINDOWS_API_KEY'] ?? "",
    appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
    messagingSenderId: '332259428605',
    projectId: 'quotemasterpushnoti',
    authDomain: 'quotemasterpushnoti.firebaseapp.com',
    storageBucket: 'quotemasterpushnoti.appspot.com',
    measurementId: 'G-XEPTRM48SE',
  );
}