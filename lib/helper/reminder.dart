import 'package:background_app/data/modal/reminder_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void addFistReminder(ReminderModel reminder) {
  Hive.box("user").put('reminders', {});
  Map<String, ReminderModel> prevReminders = Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));

  Hive.box("user").put("reminders", {...prevReminders, reminder.id: reminder});
}

void toggleAllReminder(bool value) {
  Map<String, ReminderModel> prevReminders = Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));

  prevReminders.forEach((key, reminder) {
    reminder.enabled = value;
  });

  Hive.box("user").put("reminders", {...prevReminders});
}

void addReminder(ReminderModel reminder) {
  Map<String, ReminderModel> prevReminders = Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));

  Hive.box("user").put("reminders", {...prevReminders, reminder.id: reminder});
}

Map<String, ReminderModel> getReminders() {
  Map<String, ReminderModel> prevReminders = Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));

  return prevReminders;
}

ReminderModel? getReminderById(String id) {
  Map<String, ReminderModel> prevReminders = Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));

  return prevReminders.containsKey(id) ? prevReminders[id] : null;
}

Map<String, ReminderModel> updatedReminder(ReminderModel reminder) {
  Map<String, ReminderModel> prevReminders = Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));

  Hive.box("user").put("reminders", {...prevReminders, reminder.id: reminder});

  return Map<String, ReminderModel>.from(
      Hive.box("user").get("reminders", defaultValue: {}));
}
