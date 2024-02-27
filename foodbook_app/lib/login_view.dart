import 'package:flutter/material.dart';

class login_view extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginForm(),
    );
  }

  Widget _loginForm() {
    return Form(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _usernameField(),
            _passwordField(),
            loginButton(),
            ],
        ),
      ),
      );
  }

  Widget _usernameField(){
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        icon: Icon(Icons.person),
      ),
      validator: (value) => null,
    );
  }

  Widget _passwordField() {
    return TextFormField(
        obscureText: true ,
        decoration: const InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          icon: Icon(Icons.security),
      ),
      validator: (value) => null,
    );
  }
  Widget loginButton(){
    return ElevatedButton(
      onPressed: (){},
      child: Text('Login'),
    );
  }
}