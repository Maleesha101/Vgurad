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
    apiKey: 'AIzaSyD9QD7Nq4UzP0vbw2JbiNAllTmSewDehso',
    appId: '1:124227158851:web:4bbc9532436a6c9d4465f6',
    messagingSenderId: '124227158851',
    projectId: 'vguard-d1153',
    authDomain: 'vguard-d1153.firebaseapp.com',
    storageBucket: 'vguard-d1153.firebasestorage.app',
    measurementId: 'G-W2YVP84H81',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3ScThRpiBRDsLKs2djdcu6FtW2YIk2TE',
    appId: '1:124227158851:android:26cbf299d96335dd4465f6',
    messagingSenderId: '124227158851',
    projectId: 'vguard-d1153',
    storageBucket: 'vguard-d1153.firebasestorage.app',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmRSPSS1DrYWPPebPlHs-SsCunFKoMtP0',
    appId: '1:124227158851:ios:5690966a55b85fc84465f6',
    messagingSenderId: '124227158851',
    projectId: 'vguard-d1153',
    storageBucket: 'vguard-d1153.firebasestorage.app',
    iosBundleId: 'com.example.vguard',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmRSPSS1DrYWPPebPlHs-SsCunFKoMtP0',
    appId: '1:124227158851:ios:5690966a55b85fc84465f6',
    messagingSenderId: '124227158851',
    projectId: 'vguard-d1153',
    storageBucket: 'vguard-d1153.firebasestorage.app',
    iosBundleId: 'com.example.vguard',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9QD7Nq4UzP0vbw2JbiNAllTmSewDehso',
    appId: '1:124227158851:web:a157d18c1d20fb464465f6',
    messagingSenderId: '124227158851',
    projectId: 'vguard-d1153',
    authDomain: 'vguard-d1153.firebaseapp.com',
    storageBucket: 'vguard-d1153.firebasestorage.app',
    measurementId: 'G-1VZRP7YZ1T',
  );
}
