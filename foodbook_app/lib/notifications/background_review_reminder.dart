import 'package:foodbook_app/notifications/notification_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcherRem() {
  
  Workmanager().executeTask((task, inputData) async {
    // Perform your task here
    NotificationService.showNotification(title: "We miss you...", body: "you haven't left a review in a while.");
    return Future.value(true);
  });
}

void initializeBackgroundTaskReminder() {
  Workmanager().initialize(callbackDispatcherRem, isInDebugMode: true);
  //Workmanager().registerOneOffTask("DistanceBasedTest", "NotificationDisplayDistGLOCTest");
  Workmanager workmanager = Workmanager();
  workmanager.cancelByUniqueName("reviewReminder");
  Workmanager().registerPeriodicTask(
    'reviewReminder',
    'show review reminder notification',
    frequency: const Duration(days: 4),
    initialDelay: const Duration(days: 4),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  //  Workmanager().registerPeriodicTask(
  //    'reviewReminder',
  //    'show review reminder notification',
  //    frequency: const Duration(days: 4),
  //    initialDelay: initialDelay,
  //    constraints: Constraints(
  //      networkType: NetworkType.connected,
  //    ),
  // );
  print("background task initialized");
}

void cancelSingleTask(String id) {
  Workmanager().cancelByUniqueName(id);
}



