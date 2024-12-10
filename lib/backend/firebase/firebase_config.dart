import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDYmcnvk_uFPNz_l5H343MKsbQ8dNZSMK8",
            authDomain: "auth-f5895.firebaseapp.com",
            projectId: "auth-f5895",
            storageBucket: "auth-f5895.firebasestorage.app",
            messagingSenderId: "604035721401",
            appId: "1:604035721401:web:df141b03d2d888a738d368"));
  } else {
    await Firebase.initializeApp();
  }
}
