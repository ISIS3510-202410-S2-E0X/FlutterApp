import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/auth_bloc.dart';
import 'package:foodbook_app/presentation/screens/login_confirm.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your SignInBloc here

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state == Loading) {
              return const CircularProgressIndicator();
            } else {
              return Column( 
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
              const Spacer(),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color.fromARGB(255, 0, 140, 255), // foreground (text) color
                  minimumSize: const Size(double.infinity, 50), // set the size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // set the border radius
                  ),
                ),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(GoogleSignInRequested());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginConfirmPage()),
                  );
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
                      const SizedBox(width: 10), // Add some spacing between the image and text
                      const Center(
                        child: Text('Continue with Google'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
                ],
            );
            }
          },
        ),
      ),
    );
  }
}
class LoginBtn extends StatelessWidget {
  const LoginBtn({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue, width: 1),
            minimumSize: const Size(double.infinity, 54),
            backgroundColor: Colors.blue[50]),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context)
              .add(GoogleSignInRequested());
        },
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}