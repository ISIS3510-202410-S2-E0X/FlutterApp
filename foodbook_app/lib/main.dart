import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodbook_app/firebase_options.dart';
import 'package:foodbook_app/presentation/views/login_view/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
  runApp(const MyApp());
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
      home: const LogInView(), // Assuming LoginView is your starting view
    );
  }
}


// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   final ReviewBloc reviewBloc = ReviewBloc(ReviewRepository());

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MiCaserrito Reviews',
//       home: BlocProvider(
//         create: (context) => reviewBloc,
//         child: ReviewList(),
//       ),
//     );
//   }
// }

