import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bstable/main.dart';
import 'package:bstable/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/app_logo',
      
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'important notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Action received: ${receivedAction.toString()}');
    final payload = receivedAction.payload ?? {};

    if (payload['navigate'] == 'true') {
      //MyApp.navigatorKey.currentState?.push(MaterialPageRoute(builder: (_)=>Wrapper(),))
      Get.to(() => Wrapper());
    }
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.toString()}');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.toString()}');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Action received: ${receivedAction.toString()}');
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String?>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    final int? hour,
    final int? minute,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        icon: "resource://drawable/app_logo",
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        summary: summary,
        payload: payload,
        actionType: actionType,
        notificationLayout: notificationLayout,
        category: category,
        bigPicture: bigPicture,
        wakeUpScreen: true,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar(
              hour: hour,
              minute: minute,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              allowWhileIdle: true,
              preciseAlarm: true,
              repeats: false,
            )
          : null,
    );
  }
}
