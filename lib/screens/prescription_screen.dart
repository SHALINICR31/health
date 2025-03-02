import 'package:flutter/material.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescribe Medicines")),
      body: const Center(
        child: Text(
          "Prescription details will be shown here",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
