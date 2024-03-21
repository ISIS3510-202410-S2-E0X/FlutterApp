import 'package:foodbook_app/notifications/notification_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
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
      case 'show_review_reminder_notification':
        NotificationService.showNotification(
          id: 2,
          title: "We miss you...",
          body: "you haven't left a review in a while."
          
          );
        return Future.value(true);
      default:
        print("Task no reconocida: $task");
        break;
    }
    return Future.value(true);
  });
}

void initializeBackgroundTask() {
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
  // Workmanager().registerPeriodicTask(
  //    "RecurringlocatiionUsageTest3", 
  //  "RepLocTest", 
  //  //  When no frequency is provided the default 15 minutes is set.
  //    //  Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  //    initialDelay: const Duration(minutes: 1),
  //  );
   Workmanager().registerPeriodicTask(
     'dailyEatingTest_notification',
     'show_daily_notification',
     frequency: const Duration(days: 1),
     initialDelay: initialDelay,
     constraints: Constraints(
       networkType: NetworkType.connected,
     ),
  );
  Workmanager().registerPeriodicTask(
    'reviewReminder',
    'show_review_reminder_notification',
    frequency: const Duration(days: 4),
    initialDelay: const Duration(days: 4),
  );
  print("background task initialized");
}



