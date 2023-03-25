import 'dart:developer';

import 'package:background_app/data/modal/reminder_model.dart';
import 'package:background_app/helper/reminder.dart';
import 'package:background_app/screens/update_reminder.dart';
import 'package:background_app/widgets/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  Map<String, ReminderModel> remindersList = {};

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  void loadReminders() {
    final reminders = getReminders();
    print(reminders);

    setState(() {
      remindersList = reminders;
    });
  }

  void onToggle(bool value, ReminderModel reminder) async {
    reminder.enabled = value;
    var updatedReminders = updatedReminder(reminder);
    inspect(updatedReminders);
    setState(() {
      // remindersList = updatedReminders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Reminder",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "Spectral",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Stack(
            children: [
              Flex(direction: Axis.vertical, children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    children: [
                      Text(
                        "Setup reminders to enable you to be motivated, re-affirmed & enlivened.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Lato",
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          for (String key in remindersList.keys)
                            ReminderCard(
                              reminder: remindersList[key]!,
                              onPressed: () async {
                                await Get.to(() => UpdateReminder(
                                      reminder: remindersList[key]!,
                                      title: 'Edit Reminder',
                                    ));
                                loadReminders();
                              },
                              onToggle: ((value) {
                                onToggle(value, remindersList[key]!);
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    await Get.to(() => const UpdateReminder(
                          reminder: null,
                          title: 'Add Reminder',
                        ));
                    loadReminders();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 40),
                    disabledBackgroundColor:
                        const Color.fromRGBO(31, 45, 65, 0.4),
                    disabledForegroundColor: Theme.of(context).backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Lato",
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: const Text(
                    "Add Reminder",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
