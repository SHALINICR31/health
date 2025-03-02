import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LabDashboard extends StatefulWidget {
  const LabDashboard({super.key});

  @override
  _LabDashboardState createState() => _LabDashboardState();
}

class _LabDashboardState extends State<LabDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _activateVoiceAssistant() {
    // TODO: Integrate AI-powered voice commands
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Voice Assistant Activated!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab Technician Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("View Tests"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Update Test Results"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _activateVoiceAssistant,
              child: const Text("Activate AI Voice Assistant"),
            ),
          ],
        ),
      ),
    );
  }
}
