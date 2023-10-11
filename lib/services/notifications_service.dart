import 'package:bstable/wrapper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    //final IOSInitializationSettings initializationSettingsIOS =
    //    IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap here
        //takes you to homepage
        Get.to(() => Wrapper());
      },
      //onSelectNotification: (String? payload) async {
      //  // Handle notification tap here
      //},
    );
  }

  Future<void> scheduleNotification({
    required DateTime notificationDateTime,
    required String title,
    required String body,
    int notificationId = 0,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      notificationDateTime,
      tz.local,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
    );

    //final IOSNotificationDetails iosPlatformChannelSpecifics =
    //    IOSNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      //iOS: iosPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
