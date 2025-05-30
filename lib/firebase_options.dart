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
    apiKey: 'AIzaSyA3vHl3L2HxYh77RXFxJ_o6727JMN1c5bA',
    appId: '1:256294944069:web:1bb348822fd1f8591e922c',
    messagingSenderId: '256294944069',
    projectId: 'termostato-3ab33',
    authDomain: 'termostato-3ab33.firebaseapp.com',
    databaseURL: 'https://termostato-3ab33-default-rtdb.firebaseio.com',
    storageBucket: 'termostato-3ab33.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJsevPyQF3P6l-9_QuZlUEhu-8pVL0Be4',
    appId: '1:256294944069:android:b0e4773aa09f4ff71e922c',
    messagingSenderId: '256294944069',
    projectId: 'termostato-3ab33',
    databaseURL: 'https://termostato-3ab33-default-rtdb.firebaseio.com',
    storageBucket: 'termostato-3ab33.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6moyGcgPF9_Buq2PwWZqMBTzC2PPqP5Y',
    appId: '1:256294944069:ios:4d8e30998f9849f91e922c',
    messagingSenderId: '256294944069',
    projectId: 'termostato-3ab33',
    databaseURL: 'https://termostato-3ab33-default-rtdb.firebaseio.com',
    storageBucket: 'termostato-3ab33.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6moyGcgPF9_Buq2PwWZqMBTzC2PPqP5Y',
    appId: '1:256294944069:ios:f2bc50587344a17f1e922c',
    messagingSenderId: '256294944069',
    projectId: 'termostato-3ab33',
    databaseURL: 'https://termostato-3ab33-default-rtdb.firebaseio.com',
    storageBucket: 'termostato-3ab33.firebasestorage.app',
    iosBundleId: 'com.example.termostato2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA3vHl3L2HxYh77RXFxJ_o6727JMN1c5bA',
    appId: '1:256294944069:web:6081210e1fd0b3a61e922c',
    messagingSenderId: '256294944069',
    projectId: 'termostato-3ab33',
    authDomain: 'termostato-3ab33.firebaseapp.com',
    databaseURL: 'https://termostato-3ab33-default-rtdb.firebaseio.com',
    storageBucket: 'termostato-3ab33.firebasestorage.app',
  );

}