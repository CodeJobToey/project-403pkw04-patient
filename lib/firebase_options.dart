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
    apiKey: 'AIzaSyDOgJqrV27zmTU8iRkWGp5terkykI-uQPI',
    appId: '1:665614505906:web:c0edf39f65a2f5b1a6b6ab',
    messagingSenderId: '665614505906',
    projectId: 'project-403pkw04',
    authDomain: 'project-403pkw04.firebaseapp.com',
    storageBucket: 'project-403pkw04.appspot.com',
    measurementId: 'G-6LBN0445B6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmTSDnXd_8ByEuoqfr5_JiLvLe6InVYF4',
    appId: '1:665614505906:android:027d48d26cd671dda6b6ab',
    messagingSenderId: '665614505906',
    projectId: 'project-403pkw04',
    storageBucket: 'project-403pkw04.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTLzclsXLvcj8SkTl2Y3nVMAtfCK2luWs',
    appId: '1:665614505906:ios:a297cfb466a0cf76a6b6ab',
    messagingSenderId: '665614505906',
    projectId: 'project-403pkw04',
    storageBucket: 'project-403pkw04.appspot.com',
    iosClientId: '665614505906-bs3joejqqhffs5jcgelatj7sq64vrosa.apps.googleusercontent.com',
    iosBundleId: 'com.example.project403pkw04Patient',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTLzclsXLvcj8SkTl2Y3nVMAtfCK2luWs',
    appId: '1:665614505906:ios:a297cfb466a0cf76a6b6ab',
    messagingSenderId: '665614505906',
    projectId: 'project-403pkw04',
    storageBucket: 'project-403pkw04.appspot.com',
    iosClientId: '665614505906-bs3joejqqhffs5jcgelatj7sq64vrosa.apps.googleusercontent.com',
    iosBundleId: 'com.example.project403pkw04Patient',
  );
}
