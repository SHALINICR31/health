import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'patients_screen.dart';
import 'prescription_screen.dart';
import 'chat_screen.dart';
import 'reports_screen.dart';
import 'appointments_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint("🎤 Status: $status"),
      onError: (error) => debugPrint("⚠️ Error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);
      debugPrint("🎙️ Listening started...");
      _speech.listen(
        onResult: (result) {
          setState(() {
            _command = result.recognizedWords.toLowerCase();
          });
          _navigateWithVoice(_command);
        },
      );
    } else {
      debugPrint("❌ Speech recognition not available.");
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    debugPrint("🎤 Listening stopped.");
  }

  void _navigateWithVoice(String command) {
    if (!mounted) return;

    if (command.contains("appointments")) {
      debugPrint("✅ Navigating to Appointments...");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsScreen()));
    } else if (command.contains("patients")) {
      debugPrint("✅ Navigating to Patients...");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientsScreen()));
    } else if (command.contains("prescribe")) {
      debugPrint("✅ Navigating to Prescription...");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PrescriptionScreen()));
    } else if (command.contains("chat")) {
      debugPrint("✅ Navigating to Chat...");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
    } else if (command.contains("reports")) {
      debugPrint("✅ Navigating to Reports...");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen()));
    } else {
      debugPrint("❌ Command not recognized: $_command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Dashboard")),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavigationButton("View Appointments", const AppointmentsScreen()),
            _buildNavigationButton("View Patients", const PatientsScreen()),
            _buildNavigationButton("Prescribe Medicines", const PrescriptionScreen()),
            _buildNavigationButton("Chat with Patients", const ChatScreen()),
            _buildNavigationButton("Medical Reports", const ReportsScreen()),
            const SizedBox(height: 20),
            Text(
              _isListening ? "🎙️ Listening for commands..." : "🗣️ Tap the mic button and speak",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Helper function to build navigation buttons
  Widget _buildNavigationButton(String text, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
        child: Text(text),
      ),
    );
  }
}
