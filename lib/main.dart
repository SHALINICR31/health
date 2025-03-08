import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import your existing screens
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
    await Firebase.initializeApp();
    debugPrint("✅ Firebase initialized successfully!");

    await refreshUserToken();
    await requestMicPermission();  // ✅ Request mic permission at startup
  } catch (e) {
    debugPrint("❌ Firebase initialization failed: $e");
  }
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

// 🔄 Refresh User Token (No Changes)
Future<void> refreshUserToken() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken(true);
      debugPrint("✅ User token refreshed successfully!");
    } else {
      debugPrint("❌ No user logged in!");
    }
  } catch (e) {
    debugPrint("❌ Error refreshing token: $e");
  }
}

// 🎤 Request Microphone Permission
Future<void> requestMicPermission() async {
  var status = await Permission.microphone.request();
  if (status.isGranted) {
    debugPrint("✅ Microphone permission granted!");
  } else {
    debugPrint("❌ Microphone permission denied!");
  }
}

// 🎙️ Voice Recording + Whisper API Integration
class VoiceRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _filePath;

  // Start Recording
  Future<void> startRecording() async {
    await _recorder.openRecorder();
    _filePath = 'audio.aac';  // Local storage path
    await _recorder.startRecorder(toFile: _filePath);
    debugPrint("🎙️ Recording started...");
  }

  // Stop Recording & Send to Whisper API
  Future<void> stopRecording() async {
    _filePath = await _recorder.stopRecorder();
    debugPrint("🎙️ Recording stopped. File saved at: $_filePath");

    if (_filePath != null) {
      await sendAudioToWhisper(_filePath!);
    }
  }

  // 🔊 Send Audio to Whisper API
  Future<void> sendAudioToWhisper(String filePath) async {
    final String apiKey = "YOUR_OPENAI_API_KEY"; // 🔑 Replace with your API key

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
    );
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    debugPrint("📝 Whisper Response: $responseBody");
  }
}

// 🌟 Main App Class
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
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/adminDashboard': (context) => const AdminDashboard(),
        '/doctorDashboard': (context) => const DoctorDashboard(),
        '/labDashboard': (context) => const LabDashboard(),
        '/patientDashboard': (context) => const PatientDashboard(),
      },
    );
  }
}
