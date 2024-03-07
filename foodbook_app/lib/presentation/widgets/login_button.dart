import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/auth_bloc.dart';

class LoginBtn extends StatefulWidget {
  const LoginBtn({super.key});


  @override
  _LoginBtnState createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> {
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