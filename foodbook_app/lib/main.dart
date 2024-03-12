import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/auth_bloc.dart';
import 'package:foodbook_app/data/repository/auth_repository.dart';
import 'package:foodbook_app/presentation/views/login_view/signin_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
        child: MaterialApp(
          title: 'FoodBook',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SignInView(),
          ),
        ),
        
    );
  }
}

