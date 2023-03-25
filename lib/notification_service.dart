import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails("1", "reminder_channel",
          playSound: true,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound('tone1'),
          importance: Importance.max),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static Future init({bool initSchedule = false}) async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    const ios = DarwinInitializationSettings();
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await _notification.initialize(settings, onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      // final String? payload = notificationResponse.payload;
      // print("notificaiton Clicked");
      // debugPrint(
      //     'notification payload: $payload ${notificationResponse.payload}');
    });

    if (initSchedule) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  void initTz() async {
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  static Future showNotification(
      {required int id, String? title, String? body, String? paylaod}) async {
    _notification.show(id, title, body, await _notificationDetails(),
        payload: paylaod);
  }

  static Future showScheduledWeeklyNotification(
      {required int id,
      String? title,
      String? body,
      String? paylaod,
      required DateTime scheduleTime}) async {
    _notification.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(Time(scheduleTime.hour, scheduleTime.minute, 0), days: [
          DateTime.sunday,
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
        ]), //Time(8, 0, 0)
        await _notificationDetails(),
        payload: paylaod,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future showScheduledNotification(
      {required int id,
      String? title,
      String? body,
      String? paylaod,
      required DateTime scheduleTime}) async {
    _notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleTime, tz.local), //Time(8, 0, 0)
        await _notificationDetails(),
        payload: paylaod,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledData = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledData.isBefore(now)
        ? scheduledData.add(const Duration(days: 1))
        : scheduledData;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledData = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    while (!days.contains(scheduledData.weekday)) {
      scheduledData.add(const Duration(days: 1));
    }
    return scheduledData;
  }

  List<DateTime> createDateTimeList(
      DateTime startTime, DateTime endTime, int noOfTimes) {
    List<DateTime> dateTimeList = [];
    double interval =
        endTime.difference(startTime).inMilliseconds / (noOfTimes - 1);
    for (int i = 0; i < noOfTimes; i++) {
      dateTimeList
          .add(startTime.add(Duration(milliseconds: (interval * i).round())));
    }
    return dateTimeList;
  }

 
}
