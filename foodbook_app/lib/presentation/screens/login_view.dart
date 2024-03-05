import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbook_app/user_controller.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // Adjust the value as needed
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'foodbook',
                  style: GoogleFonts.archivoBlack(
                    fontSize: 48,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Spacer(),
            Image.asset(
              'lib/presentation/images/toasty.png',
              height: 300, // Set the image height
            ),
            SizedBox(height: 8),
            Text(
              'Where good people find good food.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 0, 140, 255), // background (button) color
                  onPrimary: Colors.white, // foreground (text) color
                  minimumSize: Size(double.infinity, 50), // set the size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // set the border radius
                  ),
                ),
                onPressed: () async {
                  try {
                    final user = await UserControllers.signInWithGoogle();
                    if (user != null) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  } on FirebaseAuthException catch (error) {
                    print(error.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An error occurred' ?? "something went wrong"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align content to the left
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'lib/presentation/images/google2.jpeg',
                          height: 30, // Set the image height
                        ),
                      ),
                      SizedBox(width: 10), // Add some spacing between the image and text
                      Center(
                        child: Text('Continue with Google'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
  
