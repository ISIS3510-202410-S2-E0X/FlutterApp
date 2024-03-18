import 'package:workmanager/workmanager.dart';

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

void initializeBackgroundTask() {
  DateTime now = DateTime.now();
  DateTime nextMidday = DateTime(now.year, now.month, now.day, 12, 0);
  
  if (now.hour >= 12) {
     nextMidday = nextMidday.add(const Duration(days: 1));
  }

  Duration initialDelay = nextMidday.difference(now);
  print("initial delay: $initialDelay");
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  Workmanager().registerPeriodicTask(
    "DailyTaskRefactorTest", 
    "DailyTaskTest3", 
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    frequency: const Duration(hours: 1),
    initialDelay: const Duration(seconds: 10),
   );
  Workmanager().registerPeriodicTask(
     'dailyEating_notification',
     'show_daily_notification',
     frequency: const Duration(days: 1),
     initialDelay: initialDelay,
     constraints: Constraints(
       networkType: NetworkType.connected,
    ),
  );
  print("background task initialized");
}



