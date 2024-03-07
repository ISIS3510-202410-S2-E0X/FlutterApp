import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceAdapter {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthServiceAdapter()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      // Handle sign-in errors
      print(e.toString());
      throw Exception('Failed to sign in with Google');
    }
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      // Handle sign-out errors
      print(e.toString());
      throw Exception('Failed to sign out');
    }
  }
  
  // Other authentication methods can be added here
}
