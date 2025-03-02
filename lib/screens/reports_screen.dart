import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical Reports")),
      body: const Center(
        child: Text(
          "Medical reports will be displayed here",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
