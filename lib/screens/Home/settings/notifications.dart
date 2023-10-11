import 'package:bstable/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime scheduleTime =
    tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      scheduleTime =
          tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(child: ScheduleBtn()),
        ],
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            notificationDateTime: scheduleTime,
            title: 'Scheduled Notification',
            body: '$scheduleTime');
      },
    );
  }
}
