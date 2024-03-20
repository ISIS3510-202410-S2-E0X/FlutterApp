import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/login_bloc/auth_bloc.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/notifications/background_review_reminder.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';


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
            if (state is Loading) {
              return const CircularProgressIndicator();
            } else {
              return buildSignInContent(context);
            }
          },
        ),
      ),
    );
  }

  Widget buildSignInContent(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: screenSize.height * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Text(
            'foodbook',
            style: TextStyle(
              fontSize: screenSize.width * 0.13,
              color: Colors.black,
              fontWeight: FontWeight.bold,  
            ),
          ),
        ),
        const Spacer(),
        Image.asset(
          'lib/presentation/images/toasty.png',
          height: screenSize.height * 0.45,
        ),
        SizedBox(height: screenSize.height * 0.1),
        Text(
          'Where good people find good food.',
          style: TextStyle(
            fontSize: screenSize.width * 0.05,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        buildGoogleSignInButton(context),
        SizedBox(height: screenSize.height * 0.05),
      ],
    );
  }

  Widget buildGoogleSignInButton(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 0, 140, 255),
          minimumSize: Size(double.infinity, screenSize.height * 0.07),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenSize.width * 0.05),
          ),
        ),
        onPressed: () {
          initializeBackgroundTaskReminder();
          BlocProvider.of<AuthBloc>(context).add(GoogleSignInRequested());
          Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return BlocProvider<BrowseBloc>(
                        create: (context) => BrowseBloc(restaurantRepository: RestaurantRepository())..add(LoadRestaurants()),
                        child: BrowseView(),
                      );
                     }
                    ),
            );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenSize.width * 0.03),
              child: Image.asset(
                'lib/presentation/images/google2.jpeg',
                height: screenSize.height * 0.04,
              ),
            ),
            SizedBox(width: screenSize.width * 0.02),
            Text(
              'Continue with Google',
              style: TextStyle(fontSize: screenSize.width * 0.04),
            ),
          ],
        ),
      ),
    );
  }
}
