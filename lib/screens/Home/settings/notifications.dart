import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bstable/services/notifications_service.dart';
import 'package:bstable/ui/components/appBar.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


//this page is included in the next update

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
bool allowNotifications = false;
TimeOfDay? eventTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(name: "Notifications", back: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                
                SizedBox(
                  height: 20,
                ),
                ListTile(
                    title: Text("Allow Reminder".tr,
                        style: TextStyle(color: MyColors.iconColor,
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: Switch(
                      activeColor: MyColors.purpule,
                      inactiveThumbColor: MyColors.iconColor,
                      value: allowNotifications,
                      onChanged: (value) {
                        setState(() {
                          allowNotifications = value;
                          if (allowNotifications) {
                            NotificationsService.initializeNotification();
                          } else {
                            NotificationsService.cancelNotifications();
                          }
                        });
                      },
                    )),
                allowNotifications? GestureDetector(
                    
                    onTap: () async {
                      final currentTime = DateTime.now();
                      eventTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: currentTime.hour,
                          minute: currentTime.minute + 1,
                        ),
                      );
                      setState(() {
                      });
          
                      if (eventTime != null) {
                        final date = DateTime.now();
                        final now = DateTime(date.year, date.month, date.day,
                            eventTime!.hour, eventTime!.minute);
                        NotificationsService.showNotification(
                          title: "Wallet Pal",
                          body: "Don't forget to record your expenses",
                          payload: {"navigate": "true"},
                          notificationLayout: NotificationLayout.Inbox,
                          scheduled: true,
                          category: NotificationCategory.Reminder,
                          interval: 5,
                          hour: now.hour,
                          minute: now.minute,
                        );
                      }
                    },
                    child: TimeField(eventTime: eventTime)):SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class TimeField extends StatelessWidget {
  const TimeField({Key? key, required this.eventTime}) : super(key: key);
  final TimeOfDay? eventTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              eventTime == null
                  ? "Select the event time"
                  : eventTime!.format(context),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.timer_rounded,
            size: 18.0,
          ),
        ],
      ),
    );
  }
}