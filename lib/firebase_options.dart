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
    apiKey: 'AIzaSyCcmkPZwOjW52pnAAwUlqkiA-kLEqp1E5Y',
    appId: '1:540429427414:web:acf7ec75486dffef941f77',
    messagingSenderId: '540429427414',
    projectId: 'instagram-1e555',
    authDomain: 'instagram-1e555.firebaseapp.com',
    storageBucket: 'instagram-1e555.appspot.com',
    measurementId: 'G-LMCVGC8390',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC50YZgdm1hC3vF587emKiGCRLiCcZqf0s',
    appId: '1:540429427414:android:6f2fc998114abb70941f77',
    messagingSenderId: '540429427414',
    projectId: 'instagram-1e555',
    storageBucket: 'instagram-1e555.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVO5HZ_t-OfcFbXTyhwLXCtGJKQN9t6Ew',
    appId: '1:540429427414:ios:c4b5b1cf522aae79941f77',
    messagingSenderId: '540429427414',
    projectId: 'instagram-1e555',
    storageBucket: 'instagram-1e555.appspot.com',
    iosClientId: '540429427414-k2fl513oni22i5ve3a87ckk79lvss7vh.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagram',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVO5HZ_t-OfcFbXTyhwLXCtGJKQN9t6Ew',
    appId: '1:540429427414:ios:f9f36db6744eb658941f77',
    messagingSenderId: '540429427414',
    projectId: 'instagram-1e555',
    storageBucket: 'instagram-1e555.appspot.com',
    iosClientId: '540429427414-7cotvrvs9tubocs30bglirujju7id69a.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagram.RunnerTests',
  );
}