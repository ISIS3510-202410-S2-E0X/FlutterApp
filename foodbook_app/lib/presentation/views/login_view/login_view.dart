import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 16.0), // Adjust the value as needed
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'foodbook',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            
            Image.asset(
              'lib/presentation/images/toasty.png',
              height: 300, // Set the image height
            ),
            const SizedBox(height: 8),
            Text(
              'Where good people find good food.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            // This would be your login or sign up button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 140, 255), // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                  minimumSize: const Size(double.infinity, 50), // set the size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // set the border radius
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return BlocProvider<BrowseBloc>(
                        create: (context) => BrowseBloc(restaurantRepository: RestaurantRepository())..add(LoadRestaurants()),
                        child: BrowseView(),
                      );
                    }),
                  );
                  print('Continue with Google');
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
        ),
      ),
    );
  }
}
  
