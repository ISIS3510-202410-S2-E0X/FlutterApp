import 'package:foodbook_app/notifications/notification_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  
  Workmanager().executeTask((task, inputData) async {
    // Perform your task here
    Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("user location: $userLocation.latitude, $userLocation.longitude");
    var userLatitude = userLocation.latitude;
    var userLongitude = userLocation.longitude;
    double distance = Geolocator.distanceBetween(userLatitude, userLongitude, 6.5244, 3.3792);
    if (distance > 1000) {
       NotificationService.showNotification(
         id: 0,
         title: 'Distance Succesfully Calculated',
         body: 'Testing notification',
       );
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
  Workmanager().registerOneOffTask("DistanceBasedTest", "NotificationDisplayDistGLOCTest");
  // Workmanager().registerPeriodicTask(
  //   "DailyTaskEliminationTest", 
  //   "DailyElimTest3", 
  //   // When no frequency is provided the default 15 minutes is set.
  //   // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  //   frequency: const Duration(days: 1),
  //   initialDelay: const Duration(seconds: 10),
  //  );
  // Workmanager().registerPeriodicTask(
  //    'dailyEating_notification',
  //    'show_daily_notification',
  //    frequency: const Duration(days: 1),
  //    initialDelay: initialDelay,
  //    constraints: Constraints(
  //      networkType: NetworkType.connected,
  //   ),
  // );
  print("background task initialized");
}



