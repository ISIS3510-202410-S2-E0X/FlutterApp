import 'package:workmanager/workmanager.dart';
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

void showTestNotification() {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: null);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Scheduled Notification', // Notification title
    'This is a scheduled notification', // Notification body
    platformChannelSpecifics,
  );
}

void initializeBackgroundTask() {
  DateTime now = DateTime.now();
  DateTime nextMidday = DateTime(now.year, now.month, now.day, 12, 0);
  
  if (now.hour >= 12) {
     nextMidday = nextMidday.add(Duration(days: 1));
  }

  Duration initialDelay = nextMidday.difference(now);
  print("initial delay: $initialDelay");
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  Workmanager().registerPeriodicTask(
    "DailyTaskT3", 
    "DailyTaskTest3", 
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    frequency: Duration(hours: 1),
    initialDelay: Duration(seconds: 10),
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

void showNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: null);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Scheduled Notification', // Notification title
    'This is a scheduled notification', // Notification body
    platformChannelSpecifics,
  );
}


