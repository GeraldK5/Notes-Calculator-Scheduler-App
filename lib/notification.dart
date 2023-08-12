// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// class SmolleyNotification{
//   static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin)async{
//     var androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher.png');
//     var initializationSettings = new InitializationSettings(android: androidInitialize);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//   static Future showNotification({var id=0,required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async{
//     AndroidNotificationDetails androidNotificationDetails = new AndroidNotificationDetails('channelId', 'channelName', playSound: true, importance: Importance.max, priority: Priority.high);

//     var noti = NotificationDetails(android: androidNotificationDetails,);
//     await fln.show(id, title, body, noti);
//   }
// }
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SmolleyNotification {
  // void dailyNotification(DateTime time, String title, String body){
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(id: Random().nextInt(999), channelKey: 'channelKey',title: title, body: body),
  //     schedule: NotificationCalendar(
  //       year: time.year,
  //       month: time.month,
  //       day: time.day,
  //       hour: time.hour,
  //       minute: time.minute
  //     )
  //     );
  // }
  static Future<void> deletenotifications() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }

  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidInitializationSettings initialiseAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initialiseAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static AndroidNotificationDetails android() {
    return new AndroidNotificationDetails(
      'Smolley key',
      'Smolley channel',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  static Future ShowNotification(
      {required String title,
      required String body,
      var payload,
      required DateTime time,
      required FlutterLocalNotificationsPlugin fn}) async {
    AndroidNotificationDetails androidnotificationdetails =
        new AndroidNotificationDetails(
      'Smolley key',
      'Smolley channel',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var notification = NotificationDetails(android: androidnotificationdetails);
    tz.initializeTimeZones();
    await fn.zonedSchedule(Random().nextInt(999), title, body,
        tz.TZDateTime.from(time, tz.local), await notification,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future dailyNotification(
      {required String title,
      required String body,
      var payload,
      required DateTime time,
      required FlutterLocalNotificationsPlugin fn}) async {
    AndroidNotificationDetails androidnotificationdetails = android();
    var notification = NotificationDetails(android: androidnotificationdetails);
    tz.initializeTimeZones();
    var today = tz.TZDateTime(tz.local, DateTime.now().year,
        DateTime.now().month, DateTime.now().day, time.hour, time.minute);

    while (today.isBefore(time)) {
      // Break the loop if the schedule is after the end date
      if (today.isAfter(time)) {
        break;
      }

      await fn.zonedSchedule(
        Random().nextInt(999), // Notification ID
        title, // Notification title
        body, // Notification body
        today,
        await notification,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      // Increment the schedule to the next day
      print('dddddddddddddddddddddddddddddddddd' + today.toString());
      today = today.add(Duration(days: 1));
    }
    ShowNotification(
        title: 'Hey there! Do you know what time it is?',
        body: title,
        time: time,
        fn: fn);
  }

  static Future<void> checkScheduledNotifications(
      FlutterLocalNotificationsPlugin fn) async {
    List<PendingNotificationRequest> pendingNotifications =
        await fn.pendingNotificationRequests();

    if (pendingNotifications.isNotEmpty) {
      // Notifications are scheduled
      print('Notifications scheduled:');
      for (var notification in pendingNotifications) {
        print('ID: ${notification.id}, Title: ${notification.title}');
      }
    } else {
      // No notifications scheduled
      print('No notifications scheduled.');
    }
  }
}
