import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/login_bloc/auth_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/presentation/views/login_view/signin_view.dart';
import 'package:foodbook_app/presentation/views/review_view/user_reviews.dart';
class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    print(results);
    if (results.contains(ConnectivityResult.none)) {
      // No internet connection
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content: Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<AuthBloc>(context).add(NoInternet());
                },
              ),
            ],
          );
        },
      );
    } else {
      BlocProvider.of<AuthBloc>(context).add(InternetRecovered());
      // Internet connection is available
      // You can proceed with the sign-in process here
    }
  }
  @override
  Widget build(BuildContext context) {
    //UserBloc().add(GetCurrentUser()); // Dispatch GetCurrentUser event to UserBloc
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          //UserBloc().add(GetCurrentUser());
          print('State: $state');
          if (state is AuthenticatedUserState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(state.profileImageUrl),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.email,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to the edit profile page
                      var mail = state.email;
                      var name = state.displayName;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<ReviewBloc>(
                              create: (context) => ReviewBloc(reviewRepository: ReviewRepository(), restaurantRepository: RestaurantRepository())..add(FetchUserReviews(mail, name)),
                            ),
                            BlocProvider<BookmarkInternetViewBloc>(
                              create: (context) => BookmarkInternetViewBloc(),
                            )
                          ],
                          child: const UserReviews(),
                        ),
                      ));
                    }, 
                    child: const Text("My reviews")
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var connectivityResult = await Connectivity().checkConnectivity();
                      print("CONNECTION STATUS: $connectivityResult");
                      if (connectivityResult[0] == ConnectivityResult.none) {
                        // No internet connection
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('No Internet Connection'),
                              content: Text('Please check your internet connection and try again.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Internet connection is available
                        // Proceed with sign-out
                        BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInView()),
                        );
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );

          } else if (state is UserAuthInitial) {
            UserBloc().add(GetCurrentUser());
            return const Center(child: CircularProgressIndicator());
          } else {
            // Handle other states such as loading or error
            return const Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}