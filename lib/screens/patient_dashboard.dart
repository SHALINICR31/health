import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // ✅ Load API key safely

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
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
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: $error"),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() => _command = result.recognizedWords);
            _processCommand(_command); // ✅ Process only final speech result
          }
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _processCommand(String command) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']; // ✅ Load API key securely
    const apiUrl = "https://api.openai.com/v1/chat/completions"; // ✅ Correct API endpoint

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": command}
        ],
      }),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print("AI Response: ${result['choices'][0]['message']['content']}");
      _navigateBasedOnCommand(result['choices'][0]['message']['content']);
    } else {
      print("Error: ${response.body}");
    }
  }

  void _navigateBasedOnCommand(String command) {
    if (command.toLowerCase().contains("book appointment")) {
      Navigator.pushNamed(context, "/book_appointment");
    } else if (command.toLowerCase().contains("view medical records")) {
      Navigator.pushNamed(context, "/medical_records");
    } else if (command.toLowerCase().contains("chat with doctor")) {
      Navigator.pushNamed(context, "/chat_doctor");
    } else if (command.toLowerCase().contains("health monitoring")) {
      Navigator.pushNamed(context, "/health_monitoring");
    } else if (command.toLowerCase().contains("emergency call")) {
      Navigator.pushNamed(context, "/emergency_call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/book_appointment"),
              child: const Text("Book Appointment"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/medical_records"),
              child: const Text("View Medical Records"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/chat_doctor"),
              child: const Text("Chat with Doctor"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/health_monitoring"),
              child: const Text("Health Monitoring"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/emergency_call"),
              child: const Text("Emergency Call"),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}
