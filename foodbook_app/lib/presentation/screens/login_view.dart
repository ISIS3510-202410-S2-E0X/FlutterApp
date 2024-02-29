import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class login_view extends StatelessWidget {
  const login_view({super.key});
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
            // This would be your login or sign up button
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
                onPressed: () {
                  // Implement your login functionality
                  print('Continue with Google');
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8), // Add some spacing between the image and text
                      Text('Continue with Google'),
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
  
