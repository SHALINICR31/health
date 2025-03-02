import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import Signup Screen
import 'login_screen.dart'; // Import Login Screen

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Login Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                );
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Signup Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SignupScreen()),
                );
              },
              child: const Text("Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
