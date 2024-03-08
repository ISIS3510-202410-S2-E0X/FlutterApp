import 'package:flutter/material.dart';
import 'presentation/views/login_view/login_view.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodBook App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const login_view(), // Assuming LoginView is your starting view
    );
  }
}
