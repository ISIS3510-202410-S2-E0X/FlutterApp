import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbook_app/notifications/notification_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String emailPrefix = getEmail();  // Get sanitized email prefix

    switch (task) {
      case 'RepLocTest':
        Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print("user location: $userLocation.latitude, $userLocation.longitude");
        var userLatitude = userLocation.latitude;
        var userLongitude = userLocation.longitude;
        double distance = Geolocator.distanceBetween(userLatitude, userLongitude, 4.6028679, -74.0649262);
        if (distance > 1000) {
          NotificationService.showNotification(
            id: 1,
            title: 'Hungry?',
            body: "Choose what you will eat today and leave a review!",
          );
        }
        return Future.value(true);
      case 'show_daily_notification':
        bool? showDailyNotification = prefs.getBool(emailPrefix + 'lunchTime');
        if (showDailyNotification == true) {
          Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print("user location: $userLocation.latitude, $userLocation.longitude");
          var userLatitude = userLocation.latitude;
          var userLongitude = userLocation.longitude;
          double distance = Geolocator.distanceBetween(userLatitude, userLongitude, 4.6028679, -74.0649262);
          if (distance > 1000) {
            NotificationService.showNotification(
              id: 1,
              title: "Hungry? It's lunchtime!",
              body: "Looks like you're on campus, find a spot or rate the one you've been at!",
            );
          }
        }
        return Future.value(true);
      // case 'show_review_reminder_notification':
      //   bool? showReviewReminder = prefs.getBool(emailPrefix + 'daysSinceLastReviewEnabled');
      //   if (showReviewReminder == true) {
      //     NotificationService.showNotification(
      //       id: 2,
      //       title: "We miss you...",
      //       body: "you haven't left a review in a while."
      //     );
      //   }
      //   return Future.value(true);
      case 'task_drafts_loaded_notification':
        bool? showDraftsLoadedNotification = prefs.getBool(emailPrefix + 'reviewsUploaded');
        if (showDraftsLoadedNotification == true) {
          NotificationService.showNotification(
            id: 3,
            title: "Reviews Uploaded",
            body: "The reviews you created w/o connection have been uploaded"
          );
        }
        return Future.value(true);
      default:
        print("Task no reconocida: $task");
        break;
    }
    return Future.value(true);
  });
}

Future<void> initializeBackgroundTask() async {  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String emailPrefix = getEmail();  // Get sanitized email prefix

  bool? lunchTime = prefs.getBool(emailPrefix + 'lunchTime');
  bool? reviewReminderEnabled = prefs.getBool(emailPrefix + 'daysSinceLastReviewEnabled');
  int numberOfDays = prefs.getInt(emailPrefix + 'numberOfDays') ?? 4;  // Default to 4 if not set
  bool? draftsUploaded = prefs.getBool(emailPrefix + 'reviewsUploaded');

  DateTime now = DateTime.now();
  DateTime nextMidday = DateTime(now.year, now.month, now.day, 12, 0);
  
  if (now.hour >= 12) {
     nextMidday = nextMidday.add(const Duration(days: 1));
  }

  Duration initialDelay = nextMidday.difference(now);
  print("initial delay: $initialDelay");
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  //Workmanager().registerOneOffTask("DistanceBasedTest", "NotificationDisplayDistGLOCTest");
  Workmanager workmanager = Workmanager();
  workmanager.cancelByUniqueName("RecurringlocatiionUsageTest3");
  workmanager.cancelByUniqueName("dailyEatingTest_notification");
  workmanager.cancelByUniqueName("reviewReminder");

  if (lunchTime == true) {
    Workmanager().registerPeriodicTask(
      'dailyEatingTest_notification',
      'show_daily_notification',
      frequency: const Duration(days: 1),
      initialDelay: initialDelay,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  // if (reviewReminderEnabled == true) {
  //   Workmanager().registerPeriodicTask(
  //     'reviewReminder',
  //     'show_review_reminder_notification',
  //     frequency: Duration(days: num),
  //     initialDelay: Duration(days: 30),
  //   );
  // }

  print("background task initialized");
}

Future<void> draftsLoadNotification() async {
  String emailPrefix = getEmail(); // Get sanitized email prefix
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? draftsUploaded = prefs.getBool(emailPrefix + 'reviewsUploaded');

  if (draftsUploaded == true) {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerOneOffTask('drafts_loaded_notification', 'task_drafts_loaded_notification');
  }
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