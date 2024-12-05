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
    apiKey: 'AIzaSyBoKIOckkZHY6MmBrEE59LtKpzeSglt53Y',
    appId: '1:317419981427:web:066d353b2223357cd2f806',
    messagingSenderId: '317419981427',
    projectId: 'likeminds-sdk-app',
    authDomain: 'likeminds-sdk-app.firebaseapp.com',
    storageBucket: 'likeminds-sdk-app.appspot.com',
    measurementId: 'G-VDC4M3W7W5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp2HimWufInSMnLc7ndFBEpeSDTj7Fxsw',
    appId: '1:317419981427:android:383c84d581bad91bd2f806',
    messagingSenderId: '317419981427',
    projectId: 'likeminds-sdk-app',
    storageBucket: 'likeminds-sdk-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVmbe-8jgnO2MUnFotMdp2tmDVnwTZqfE',
    appId: '1:317419981427:ios:5c2e7053ed57f4b2d2f806',
    messagingSenderId: '317419981427',
    projectId: 'likeminds-sdk-app',
    storageBucket: 'likeminds-sdk-app.appspot.com',
    iosBundleId: 'com.likeminds.chat.flutter.sample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVmbe-8jgnO2MUnFotMdp2tmDVnwTZqfE',
    appId: '1:317419981427:ios:5c2e7053ed57f4b2d2f806',
    messagingSenderId: '317419981427',
    projectId: 'likeminds-sdk-app',
    storageBucket: 'likeminds-sdk-app.appspot.com',
    iosBundleId: 'com.likeminds.chat.flutter.sample',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBoKIOckkZHY6MmBrEE59LtKpzeSglt53Y',
    appId: '1:317419981427:web:4437716c13e11f97d2f806',
    messagingSenderId: '317419981427',
    projectId: 'likeminds-sdk-app',
    authDomain: 'likeminds-sdk-app.firebaseapp.com',
    storageBucket: 'likeminds-sdk-app.appspot.com',
    measurementId: 'G-597NEX8YCE',
  );

}