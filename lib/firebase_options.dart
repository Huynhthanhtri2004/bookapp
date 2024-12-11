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
    apiKey: 'AIzaSyDvOfc4S5hF4MXZhy7trSCVpplpTVudSHw',
    appId: '1:615618970582:web:7dd04f13b9543f61cc5a77',
    messagingSenderId: '615618970582',
    projectId: 'book-app-93be6',
    authDomain: 'book-app-93be6.firebaseapp.com',
    storageBucket: 'book-app-93be6.firebasestorage.app',
    measurementId: 'G-NZLG2S0JJ8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTckdoqLvga4q4BcGIDGF3b67xRWItP8U',
    appId: '1:615618970582:android:c3dea150f73dfd5fcc5a77',
    messagingSenderId: '615618970582',
    projectId: 'book-app-93be6',
    storageBucket: 'book-app-93be6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIVqkAAFi_sh-K0aaGCOh_s4QaqIY6obs',
    appId: '1:615618970582:ios:a49b47547e5863b4cc5a77',
    messagingSenderId: '615618970582',
    projectId: 'book-app-93be6',
    storageBucket: 'book-app-93be6.firebasestorage.app',
    iosBundleId: 'com.example.uploadimagesFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIVqkAAFi_sh-K0aaGCOh_s4QaqIY6obs',
    appId: '1:615618970582:ios:a49b47547e5863b4cc5a77',
    messagingSenderId: '615618970582',
    projectId: 'book-app-93be6',
    storageBucket: 'book-app-93be6.firebasestorage.app',
    iosBundleId: 'com.example.uploadimagesFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDvOfc4S5hF4MXZhy7trSCVpplpTVudSHw',
    appId: '1:615618970582:web:2f0e1d81f0a1a212cc5a77',
    messagingSenderId: '615618970582',
    projectId: 'book-app-93be6',
    authDomain: 'book-app-93be6.firebaseapp.com',
    storageBucket: 'book-app-93be6.firebasestorage.app',
    measurementId: 'G-B35JZY8SJ9',
  );
}