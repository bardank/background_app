import 'package:background_app/data/modal/reminder_model.dart';
import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onPressed;
  final Function(bool value) onToggle;

  const ReminderCard(
      {Key? key,
      required this.reminder,
      required this.onPressed,
      required this.onToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onPressed();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
            margin: const EdgeInsets.all(6.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(1, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "General",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Lato",
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${reminder.timesNo}x",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Lato",
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            if (reminder.repeatDays.length == 7)
                              const Text(
                                "Every Day",
                                style: TextStyle(
                                  color: Color.fromRGBO(31, 45, 65, 0.4),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Lato",
                                ),
                              )
                            else
                              for (String day in reminder.repeatDays) ...[
                                Text(
                                  day,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(31, 45, 65, 0.4),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Lato",
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ]
                          ],
                        )
                      ],
                    ),
                    Switch(
                      activeColor: Colors.green,
                      value: reminder.enabled,
                      onChanged: (value) {
                        onToggle(value);
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
