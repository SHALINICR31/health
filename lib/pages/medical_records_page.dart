import 'package:flutter/material.dart';

class MedicalRecordsPage extends StatelessWidget {
  const MedicalRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical Records")),
      body: Center(
        child: Text(
          "📄 Your Medical Records will be displayed here.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
