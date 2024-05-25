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
      case 'show_daily_notification':
        bool? showDailyNotification = prefs.getBool(emailPrefix + 'lunchTime');
        if (showDailyNotification ?? false) {
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
        break;
      case 'show_review_reminder_notification':
        bool? showReviewReminder = prefs.getBool(emailPrefix + 'daysSinceLastReviewEnabled');
        if (showReviewReminder ?? false) {
          NotificationService.showNotification(
            id: 2,
            title: "We miss you...",
            body: "you haven't left a review in a while."
          );
        }
        break;
      case 'task_drafts_loaded_notification':
        bool? showDraftsLoadedNotification = prefs.getBool(emailPrefix + 'reviewsUploaded');
        if (showDraftsLoadedNotification ?? false) {
          NotificationService.showNotification(
            id: 3,
            title: "Reviews Uploaded",
            body: "The reviews you created w/o connection have been uploaded"
          );
        }
        break;
      default:
        print("Task not recognized: $task");
        break;
    }
    return Future.value(true);
  });
}

void initializeBackgroundTask() async {
  try {
    String emailPrefix = getEmail();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve settings from SharedPreferences using the email prefix
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

    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    Workmanager workmanager = Workmanager();
    workmanager.cancelByUniqueName("RecurringlocatiionUsageTest3");
    workmanager.cancelByUniqueName("dailyEatingTest_notification");
    workmanager.cancelByUniqueName("reviewReminder");

    // Conditional task registrations
    if (lunchTime == true) {
      Workmanager().registerPeriodicTask(
        'dailyEatingTest_notification',
        'show_daily_notification',
        frequency: const Duration(days: 1),
        initialDelay: initialDelay,
        constraints: Constraints(networkType: NetworkType.connected),
      );
    }

    if (reviewReminderEnabled == true) {
      Workmanager().registerPeriodicTask(
        'reviewReminder',
        'show_review_reminder_notification',
        frequency: Duration(days: numberOfDays),
        initialDelay: Duration(days: numberOfDays),
      );
    }
    print("Background tasks initialized based on user-specific settings.");
  } catch (e) {
    print("Error initializing background tasks: $e");
  }
}

void draftsLoadNotification() async {
  try {
    String emailPrefix = getEmail(); // Get sanitized email prefix
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the 'reviewsUploaded' setting using the email prefix
    bool? draftsUploaded = prefs.getBool(emailPrefix + 'reviewsUploaded');

    if (draftsUploaded == true) {
      Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      Workmanager().registerOneOffTask('drafts_loaded_notification', 'task_drafts_loaded_notification');
      print("Drafts load notification task has been registered.");
    } else {
      print("Drafts load notification task not registered due to user setting.");
    }
  } catch (e) {
    print("Error in draftsLoadNotification: $e");
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

