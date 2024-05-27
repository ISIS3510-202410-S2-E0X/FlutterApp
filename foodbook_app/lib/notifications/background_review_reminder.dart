import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbook_app/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';


void callbackDispatcherRem(task) {
  Workmanager().executeTask((task, inputData) async {
    // Perform your task here
    NotificationService.showNotification(
      id: 2,
      title: "We miss you...",
      body: "you haven't left a review in a while."
      
      );
    return Future.value(true);
  });
}

Future<void> initializeBackgroundTaskReminder() async {
  String emailPrefix = getEmail();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? reviewReminderEnabled = prefs.getBool(emailPrefix + 'daysSinceLastReviewEnabled');
  int numberOfDays = prefs.getInt(emailPrefix + 'numberOfDays') ?? 4;  // Default to 4 if not set

  Workmanager().initialize(callbackDispatcherRem, isInDebugMode: true);
  //Workmanager().registerOneOffTask("DistanceBasedTest", "NotificationDisplayDistGLOCTest");
  Workmanager workmanager = Workmanager();
  workmanager.cancelByUniqueName("reviewReminder");

  if (reviewReminderEnabled == true) {
    Workmanager().registerPeriodicTask(
      'reviewReminder',
      'show review reminder notification',
      frequency: Duration(minutes: numberOfDays),
      initialDelay: Duration(minutes: numberOfDays),
    );
  }

  print("background reminder task initialized");
}

void cancelSingleTask(String id) {
  NotificationService.cancelNotification(2);
  Workmanager().cancelByUniqueName(id);
}

String getEmail() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null && user.email != null) {
    return sanitizeEmail(user.email!);
  } else {
    throw Exception("User is not logged in or email is null.");
  }
}

String sanitizeEmail(String email) {
  return email.replaceAll('.', '_').replaceAll('@', '_');
}
