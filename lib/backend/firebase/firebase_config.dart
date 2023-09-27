import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBlDW_iU8UCsodSbaHKPSK83-Fi6c4flXw",
            authDomain: "pdm2-57815.firebaseapp.com",
            projectId: "pdm2-57815",
            storageBucket: "pdm2-57815.appspot.com",
            messagingSenderId: "970678976261",
            appId: "1:970678976261:web:ef486766edeac7c9e2c16c"));
  } else {
    await Firebase.initializeApp();
  }
}
