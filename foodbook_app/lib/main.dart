import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/login_bloc/auth_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/data/repositories/auth_repository.dart';
import 'package:foodbook_app/notifications/background_task.dart';
import 'package:foodbook_app/notifications/notification_service.dart';
import 'package:foodbook_app/presentation/views/login_view/signin_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); // Set up background message handler
  NotificationService.init(); // Initialize notification service
  await requestLocationPermission();   // Request location permission
  initializeBackgroundTask(); // Initialize background task
  runApp(const MyApp());
}

Future<void> requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, don't continue
    // accessing the position and request users of the 
    // app to enable the location services.
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your app should show an explanatory UI now.
      throw Exception('Location permissions are denied.');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    throw Exception('Location permissions are permanently denied, we cannot request permissions.');
  } 
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(),
          ),
        ],
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
