import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../data_sources/AuthServiceAdapter.dart';

class AuthRepository {
  final AuthServiceAdapter _authServiceAdapter = AuthServiceAdapter();

  Future<UserCredential> signInWithGoogle() async {
    UserCredential uc = await _authServiceAdapter.signInWithGoogle();
    print('USUARIO: $uc.user?');
    return uc;
  }
  Future<void> signOut() async {
    return await _authServiceAdapter.signOut();
  }
}
