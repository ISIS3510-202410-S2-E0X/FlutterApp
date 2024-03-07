import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../data_sources/AuthServiceAdapter.dart';

class AuthRepository {
  final AuthServiceAdapter _authServiceAdapter = AuthServiceAdapter();

  Future<UserCredential> signInWithGoogle() async {
    return _authServiceAdapter.signInWithGoogle();
  }
  Future<void> signOut() async {
    return _authServiceAdapter.signOut();
  }
}
