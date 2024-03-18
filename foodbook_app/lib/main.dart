import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/login_bloc/auth_bloc.dart';
import 'package:foodbook_app/data/repository/auth_repository.dart';
import 'package:foodbook_app/notifications/backgroundTask.dart';
import 'package:foodbook_app/presentation/views/login_view/signin_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  
Workmanager().executeTask((task, inputData) {
     // Perform your task here
     print("background task executed");
     //showNotification();
     //showTestNotification();
     return Future.value(true);
   }); 
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); // Set up background message handler
  initializeBackgroundTask(); // Initialize background task
  // Workmanager().initialize(
  //   callbackDispatcher, // The top level function, aka callbackDispatcher
  //   isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  // );
  // //Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  // Workmanager().registerPeriodicTask(
  //   "2",
     
  //   //This is the value that will be
  //   // returned in the callbackDispatcher
  //   "simplePeriodicTask",
     
  //   // When no frequency is provided
  //   // the default 15 minutes is set.
  //   // Minimum frequency is 15 min.
  //   // Android will automatically change
  //   // your frequency to 15 min
  //   // if you have configured a lower frequency.
  //   frequency: Duration(minutes: 15),
  // );
  // final initialDelay = initializeBackgroundTaskDelay();
  // Workmanager().registerPeriodicTask(
  //   'daily_notification',
  //   'show_daily_notification',
  //   frequency: const Duration(days: 1),
  //   //initialDelay: const Duration(seconds: 30),
  // );
  runApp(const MyApp());
}

Future<void> initNotification() async {
  // ignore: prefer_const_declarations
  final AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(
    android: androidInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

