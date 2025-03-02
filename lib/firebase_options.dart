import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAsKqYmbtNARN3RnPT4cHX6sEtbMFwc7xo",
    authDomain: "health-331b6.firebaseapp.com",
    projectId: "health-331b6",
    storageBucket: "health-331b6.firebasestorage.app",
    messagingSenderId: "76310317087",
    appId: "1:76310317087:web:444f5a6fc2ea3480356d2a",
    measurementId: "G-XXXXXXXXXX", // If available, add Measurement ID from Firebase Console
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAsKqYmbtNARN3RnPT4cHX6sEtbMFwc7xo",
    appId: "1:76310317087:android:444f5a6fc2ea3480356d2a",
    messagingSenderId: "76310317087",
    projectId: "health-331b6",
    storageBucket: "health-331b6.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAsKqYmbtNARN3RnPT4cHX6sEtbMFwc7xo",
    appId: "1:76310317087:ios:444f5a6fc2ea3480356d2a",  // Check this in Firebase Console under iOS setup
    messagingSenderId: "76310317087",
    projectId: "health-331b6",
    storageBucket: "health-331b6.firebasestorage.app",
    iosBundleId: "com.example.health",  // Ensure this matches your iOS Bundle ID
  );
}
