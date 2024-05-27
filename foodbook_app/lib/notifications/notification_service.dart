import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: null);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }
static Future<void> schedulePeriodicNotification() async {
  print("scheduling periodic notification");
  const int id = 4;
  const String title = 'We miss you...';
  const String body = 'You haven\'t left a review in a while.';

  // Set up the notification details
  const AndroidNotificationDetails androidPlatformChannelSpecificsR =
      AndroidNotificationDetails(
    'Reviewchannel',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecificsR);

  // Schedule the periodic notification
  await _flutterLocalNotificationsPlugin.periodicallyShow(
    id,
    title,
    body,
    RepeatInterval.everyMinute,
    platformChannelSpecifics,
    payload: 'item x',
  );
  print("periodic notification scheduled");
}


  static Future<void> scheduleNotification() async {
    const int id = 4 ;
    const String title = 'We miss you...';
    const String body = 'This notification was scheduled days ago';

    // Calculate the date and time four days from now
    final now = DateTime.now();
    final scheduledDate = now.add(const Duration(minutes: 5));

    // Set up the notification details
    const AndroidNotificationDetails androidPlatformChannelSpecificsR =
        AndroidNotificationDetails(
      'RevChannel',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecificsR);

    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> showNotification({required int id, required String title, required String body, var payload,}) async {
    print("showing notification_$id");

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'foodbookNotifChannel',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
  
}

