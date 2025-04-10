import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signup with Email & Password
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Signup Error: $e");
      return null;
    }
  }

  // Login with Email & Password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
