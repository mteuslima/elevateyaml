import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBkjwb-1qOxGneex-P9SSnRsELr15hgVew',
    appId: '1:855032925376:web:70d49180f36c12beaaf125',
    messagingSenderId: '855032925376',
    projectId: 'elevate-6054c',
    authDomain: 'elevate-6054c.firebaseapp.com',
    storageBucket: 'elevate-6054c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkjwb-1qOxGneex-P9SSnRsELr15hgVew',
    appId: '1:855032925376:android:70d49180f36c12beaaf125',
    messagingSenderId: '855032925376',
    projectId: 'elevate-6054c',
    authDomain: 'elevate-6054c.firebaseapp.com',
    storageBucket: 'elevate-6054c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkjwb-1qOxGneex-P9SSnRsELr15hgVew',
    appId: '1:855032925376:ios:70d49180f36c12beaaf125',
    messagingSenderId: '855032925376',
    projectId: 'elevate-6054c',
    authDomain: 'elevate-6054c.firebaseapp.com',
    storageBucket: 'elevate-6054c.firebasestorage.app',
    iosBundleId: 'com.mycompany.elevate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkjwb-1qOxGneex-P9SSnRsELr15hgVew',
    appId: '1:855032925376:ios:70d49180f36c12beaaf125',
    messagingSenderId: '855032925376',
    projectId: 'elevate-6054c',
    authDomain: 'elevate-6054c.firebaseapp.com',
    storageBucket: 'elevate-6054c.firebasestorage.app',
    iosBundleId: 'com.mycompany.elevate',
  );
}