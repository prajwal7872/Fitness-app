// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAEz16uF0kyliV5-HAEicM80RkpuSajUPA',
    appId: '1:679944214675:web:cf0b4abbcfffda4d3f9566',
    messagingSenderId: '679944214675',
    projectId: 'loginpage2-1b849',
    authDomain: 'loginpage2-1b849.firebaseapp.com',
    storageBucket: 'loginpage2-1b849.firebasestorage.app',
    measurementId: 'G-0TCV15RT7N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAy33zaCetbY54xMsrRUIjvAzSpiXoJSQ',
    appId: '1:679944214675:android:6796bfd944c400c13f9566',
    messagingSenderId: '679944214675',
    projectId: 'loginpage2-1b849',
    storageBucket: 'loginpage2-1b849.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyahGfdmvDzlZsW7UNnUNM9bN-fna8vac',
    appId: '1:679944214675:ios:02bbd350f650a2193f9566',
    messagingSenderId: '679944214675',
    projectId: 'loginpage2-1b849',
    storageBucket: 'loginpage2-1b849.firebasestorage.app',
    iosBundleId: 'com.example.loginpage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyahGfdmvDzlZsW7UNnUNM9bN-fna8vac',
    appId: '1:679944214675:ios:02bbd350f650a2193f9566',
    messagingSenderId: '679944214675',
    projectId: 'loginpage2-1b849',
    storageBucket: 'loginpage2-1b849.firebasestorage.app',
    iosBundleId: 'com.example.loginpage',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAEz16uF0kyliV5-HAEicM80RkpuSajUPA',
    appId: '1:679944214675:web:6050e8a1256fdf693f9566',
    messagingSenderId: '679944214675',
    projectId: 'loginpage2-1b849',
    authDomain: 'loginpage2-1b849.firebaseapp.com',
    storageBucket: 'loginpage2-1b849.firebasestorage.app',
    measurementId: 'G-13S9LZKWCB',
  );

}