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
      onStatus: (status) => print("🎤 Status: $status"),
      onError: (error) => print("❌ Error: $error"),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            print("🗣️ Heard from mic: ${result.recognizedWords}");
            setState(() => _command = result.recognizedWords);
            _processCommand(_command);
          }
        },
      );
    } else {
      print("❌ Speech recognition not available!");
    }
  }


  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Future<void> _processCommand(String command) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']; // ✅ Secure API key
    if (apiKey == null || apiKey.isEmpty) {
      print("❌ Error: OpenAI API key not found in .env file!");
      return;
    }

    const apiUrl = "https://api.openai.com/v1/chat/completions";

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
      String aiResponse = result['choices'][0]['message']['content'];
      print("🤖 AI Response: $aiResponse");
      _navigateBasedOnCommand(aiResponse);
    } else {
      print("❌ API Error: ${response.body}");
    }
  }

  void _navigateBasedOnCommand(String command) {
    String lowerCommand = command.toLowerCase();
    if (lowerCommand.contains("book appointment")) {
      Navigator.pushNamed(context, "/book_appointment");
    } else if (lowerCommand.contains("view medical records")) {
      Navigator.pushNamed(context, "/medical_records");
    } else if (lowerCommand.contains("chat with doctor")) {
      Navigator.pushNamed(context, "/chat_doctor");
    } else if (lowerCommand.contains("health monitoring")) {
      Navigator.pushNamed(context, "/health_monitoring");
    } else if (lowerCommand.contains("emergency call")) {
      Navigator.pushNamed(context, "/emergency_call");
    } else {
      print("⚠️ Command not recognized: $command");
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
            _buildNavButton("Book Appointment", "/book_appointment"),
            _buildNavButton("View Medical Records", "/medical_records"),
            _buildNavButton("Chat with Doctor", "/chat_doctor"),
            _buildNavButton("Health Monitoring", "/health_monitoring"),
            _buildNavButton("Emergency Call", "/emergency_call"),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String text, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(12)),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
