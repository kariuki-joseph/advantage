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
    apiKey: 'AIzaSyAO36tsu6RFKrdGfklNyqtS0gPTmlylWFM',
    appId: '1:842278875570:web:68cbb4b2a1c0da62d234ab',
    messagingSenderId: '842278875570',
    projectId: 'advantage-5b7f7',
    authDomain: 'advantage-5b7f7.firebaseapp.com',
    storageBucket: 'advantage-5b7f7.appspot.com',
    measurementId: 'G-9265HHGE8K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsUf3c-LBA9ZRuuPar-_ZybrTrYm2W5Q4',
    appId: '1:842278875570:android:651357fb7872d77ad234ab',
    messagingSenderId: '842278875570',
    projectId: 'advantage-5b7f7',
    storageBucket: 'advantage-5b7f7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBajbP2u_CkH0ccKoh1FaOiitMspNXg73E',
    appId: '1:842278875570:ios:47e652c142c5c364d234ab',
    messagingSenderId: '842278875570',
    projectId: 'advantage-5b7f7',
    storageBucket: 'advantage-5b7f7.appspot.com',
    iosBundleId: 'com.example.advantage',
  );
}