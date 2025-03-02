import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/welcome_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/doctor_dashboard.dart';
import 'screens/lab_dashboard.dart';
import 'screens/patient_dashboard.dart';
import 'screens/role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();  // ✅ Handle Firebase initialization properly
    debugPrint("✅ Firebase initialized successfully!");

    await refreshUserToken();  // ✅ Refresh token after successful Firebase initialization
  } catch (e) {
    debugPrint("❌ Firebase initialization failed: $e");
  }

  runApp(const MyApp());
}

Future<void> refreshUserToken() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken(true);  // 🔄 Force refresh token
      debugPrint("✅ User token refreshed successfully!");
    } else {
      debugPrint("❌ No user logged in!");
    }
  } catch (e) {
    debugPrint("❌ Error refreshing token: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/roleSelection': (context) => const RoleSelectionScreen(),
        '/signup': (context) =>  SignupScreen(),
        '/login': (context) =>  LoginScreen(),
        '/adminDashboard': (context) => const AdminDashboard(),
        '/doctorDashboard': (context) => const DoctorDashboard(),
        '/labDashboard': (context) => const LabDashboard(),
        '/patientDashboard': (context) => const PatientDashboard(),
      },
    );
  }
}
