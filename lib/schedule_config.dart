import 'dart:math';

import 'package:background_app/controller/affirmation_controller.dart';
import 'package:background_app/data/modal/enums.dart';
import 'package:background_app/helper/reminder.dart';
import 'package:background_app/notification_service.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:intl/intl.dart';
import 'package:background_app/data/modal/reminder_model.dart' ;

import 'data/modal/affirmation_modal.dart';

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }

  print("[BackgroundFetch] Headless event received: $taskId");

  var timestamp = DateTime.now();

  if (taskId == 'flutter_background_fetch') {
    NotificationApi.init(initSchedule: true);
    setNotificationAndUpdateWidget();
    print('[BackgroundFetch] Event received.');
    BackgroundFetch.finish(taskId);
  }
  BackgroundFetch.finish(taskId);
}

@pragma('vm:entry-point')
void onBackgroundFetch(String taskId) async {
  if (taskId == "flutter_background_fetch") {
    NotificationApi.init(initSchedule: true);
    setNotificationAndUpdateWidget();

    print('[BackgroundFetch] Event received.');
    BackgroundFetch.finish(taskId);
  }
  // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  // for taking too long in the background.
  BackgroundFetch.finish(taskId);
}


Future<bool> setNotificationAndUpdateWidget() async {
  var reminders = getReminders();

  int totalAffirmationCount = 0;
  AffirmationController affirmationController = AffirmationController();
  List<String> reminderKeys = [];
  DateTime now = DateTime.now();
  for (String key in reminders.keys) {
    ReminderModel reminder = reminders[key]!;
    if (reminder.enabled &&
        reminder.repeatDays
            .contains(DateFormat('EEE').format(now).toLowerCase())) {
      reminderKeys.add(key);
      totalAffirmationCount += reminder.timesNo;
     
    }
  }
 

  List<Affirmation>? result = await affirmationController.queryAffirmation(
    variables: {
      "fetchAffirmationsInput": {
        "type": AffirmationTypes.tx.toShortString(),
        "pageNo": 0,
        "count": totalAffirmationCount > 0 ? totalAffirmationCount : 1
      },
    },
  );

  int affirmationIndex = 0;

  if (result != null) {
    for (String key in reminderKeys) {
      ReminderModel reminder = reminders[key]!;
      if (reminder.enabled) {
        int noOfAffirmations = reminder.timesNo;
        DateTime startTime = DateTime(now.year, now.month, now.day,
            reminders[key]!.startTime.hour, reminders[key]!.startTime.minute);
        DateTime endTime = DateTime(now.year, now.month, now.day,
            reminders[key]!.endTime.hour, reminders[key]!.endTime.minute);

        List<DateTime> listOfIntervals =
            createDateTimeList(startTime, endTime, noOfAffirmations);

        DateTime sessionEndTime = now.add(const Duration(minutes: 15));

        print(("======= startTime ${DateFormat('hh:mm a').format(startTime)}"));

        for (DateTime interval in listOfIntervals) {
          print(("=======${DateFormat('hh:mm a').format(interval)}"));
          // this service is called every 15 minutes so we show notificaion for next 15min only
          if ((interval.isAfter(now) && interval.isBefore(sessionEndTime))) {
            NotificationApi.showScheduledNotification(
              id: Random.secure().nextInt(4000),
              title: "Affirm Daily",
              body: result[affirmationIndex].caption,
              scheduleTime: interval,
            );

            Affirmation affirmation = result[affirmationIndex];
            affirmation.createdAt = DateTime.now();

            // scheduleTime = scheduleTime.add(Duration(minutes: increasedBy));
            affirmationIndex = affirmationIndex + 1;
          }
        }

        print(("======= endTime ${DateFormat('hh:mm a').format(endTime)}"));
      }
    }

    return Future.value(true);
  } else {
    return Future.value(false);
  }
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
