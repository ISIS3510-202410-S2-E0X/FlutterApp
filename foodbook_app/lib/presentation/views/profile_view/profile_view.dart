import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/login_bloc/auth_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/presentation/views/login_view/signin_view.dart';
class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
                ElevatedButton(
                onPressed: () {
                  // Dispatch sign-out event to AuthBloc
                  BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInView()),
                  );
                },
                child: const Text('Sign Out'),
                ),
              ],
              ),
            );
            
          }else if (state is UserAuthInitial) {
            UserBloc().add(GetCurrentUser());
            return const Center(child: CircularProgressIndicator());
          } 
          else {
            // Handle other states such as loading or error
            return const Center(child: CircularProgressIndicator());
          }
        
        },
      ),
    );
  }
}
