import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Riverpod state provider to track authentication state
final authProvider = StateProvider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});
