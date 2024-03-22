import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserControllers{
  static Future<User?> signInWithGoogle() async {
    // Trigger the Google Sign In process
    final googleUser = await GoogleSignIn().signIn();

    // If the process was cancelled, return null
    if (googleUser == null) return null;

    // Get the Google Sign In authentication object
    final googleAuth = await googleUser.authentication;

    // Create a new credential object
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google Auth credential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Return the User object from the UserCredential
    return userCredential.user;
  }
}