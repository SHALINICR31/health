import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// AuthController to manage authentication state
final authControllerProvider = StateNotifierProvider<AuthController, User?>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<User?> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  AuthController() : super(null);

  // Login method
  Future<void> login(String email, String password) async {
    User? user = await _authService.signInWithEmail(email, password);
    if (user != null) {
      state = user;
    }
  }

  // Logout method
  Future<void> logout() async {
    await _authService.signOut();
    state = null;
  }
}
