import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String get token {
    return _token;
  }

  Future<void> signUp(String email, String password) async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    // FirebaseApp
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _token = await response.user!.getIdToken();
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }
}
