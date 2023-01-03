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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyAv0fqhbq5RD94G12SW19aOJYgxub2_v1Q',
    appId: '1:952997310244:web:2c6d68accc5eec275d0db1',
    messagingSenderId: '952997310244',
    projectId: 'app-pesquis-satisf-mumbuca',
    authDomain: 'app-pesquis-satisf-mumbuca.firebaseapp.com',
    storageBucket: 'app-pesquis-satisf-mumbuca.appspot.com',
    measurementId: 'G-NX1EHYB4PZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4VLJLH0AjBh1hI4yYvifNMBQbSU4c2OE',
    appId: '1:952997310244:android:17349e74f3033f3e5d0db1',
    messagingSenderId: '952997310244',
    projectId: 'app-pesquis-satisf-mumbuca',
    storageBucket: 'app-pesquis-satisf-mumbuca.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2c5yRXQX4Ysqzu1LQOHM3CEIAXnfSDGw',
    appId: '1:952997310244:ios:d3a305180dcb59e35d0db1',
    messagingSenderId: '952997310244',
    projectId: 'app-pesquis-satisf-mumbuca',
    storageBucket: 'app-pesquis-satisf-mumbuca.appspot.com',
    iosClientId: '952997310244-kn50mhm70eucelshnokjpqdvbodn9ihk.apps.googleusercontent.com',
    iosBundleId: 'com.example.appmumbuca',
  );
}
