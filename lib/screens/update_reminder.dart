import 'package:background_app/data/modal/reminder_model.dart';
import 'package:background_app/helper/reminder.dart';
import 'package:background_app/widgets/large_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class UpdateReminder extends StatefulWidget {
  final ReminderModel? reminder;
  final String title;
  const UpdateReminder({super.key, required this.title, this.reminder});

  @override
  State<UpdateReminder> createState() => _UpdateReminderState();
}

class _UpdateReminderState extends State<UpdateReminder> {
  TimeOfDay startTime = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 00);
  int times = 12;
  List<String> _selectedTypes = [];

  Uuid uuid = const Uuid();
  List<String> _selectedSubCategories = ["General"];
  static List<String> days = Days.values.map((e) => e.name).toList();

  List<String> selectedDays = [];
  List<String> typeOptions = [
    "Action",
    "Affirmations",
    "Bible-Deep",
    "Bible-verse",
    "Quotes"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      setState(() {
        selectedDays = widget.reminder!.repeatDays;
        times = widget.reminder!.timesNo;
        startTime = TimeOfDay(
            hour: widget.reminder!.startTime.hour,
            minute: widget.reminder!.startTime.minute);
        endTime = TimeOfDay(
            hour: widget.reminder!.endTime.hour,
            minute: widget.reminder!.endTime.minute);
        _selectedSubCategories = widget.reminder!.subCategory.isEmpty
            ? ["General"]
            : widget.reminder!.subCategory;
        _selectedTypes = widget.reminder!.affirmationType;
      });
    } else {
      setState(() {
        selectedDays = Days.values.map((e) => e.name).toList();
      });
    }
  }

  void listenNotification() {}

  void onContinue() async {
    List<String> sortedDays = selectedDays;
    sortedDays.sort((a, b) => days.indexOf(a).compareTo(days.indexOf(b)));
    ReminderModel newReminder = ReminderModel(
      id: widget.reminder == null ? uuid.v4() : widget.reminder!.id,
      endTime: Time(hour: endTime.hour, minute: endTime.minute),
      startTime: Time(hour: startTime.hour, minute: startTime.minute),
      timesNo: times,
      repeatDays: sortedDays,
      enabled: true,
      subCategory: _selectedSubCategories,
      affirmationType: _selectedTypes,
    );
    addReminder(newReminder);

    Get.back();
  }

  TimeOfDay addHour(TimeOfDay time) {
    int newHour = time.hour != 23 ? time.hour + 1 : 0;
    TimeOfDay newTime = time.replacing(hour: newHour, minute: time.minute);

    return newTime;
  }

  TimeOfDay subHour(TimeOfDay time) {
    int newHour = time.hour == 0 ? 23 : time.hour - 1;

    TimeOfDay newTime = time.replacing(hour: newHour, minute: time.minute);

    return newTime;
  }

  getformattedTime(TimeOfDay time) {
    var newTime = time.replacing(hour: time.hourOfPeriod);
    return '${newTime.hour}:${newTime.minute < 10 ? "0${newTime.minute}" : newTime.minute} ${time.period.toString().split('.')[1].toUpperCase()}';
  }

  toggleDaySelect(String item) {
    if (selectedDays.contains(item)) {
      var prevDays = selectedDays;
      prevDays.removeWhere((i) => item == i);

      setState(() {
        selectedDays = prevDays;
      });
    } else {
      setState(() {
        selectedDays = [...selectedDays, item];
      });
    }
  }

  void onCategoryChange(List<String> categories) {
    setState(() {
      _selectedSubCategories = categories;
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
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "Spectral",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: Stack(
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      'How many  ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontFamily: 'lato',
                                      ),
                                    ),
                                    toolTipBuilder(
                                        'How many times do you want your affirmation to change in the selected time frame')
                                  ],
                                ),
                              ),
                              Flexible(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RemoveWidget(
                                    onPressed: () {
                                      setState(() {
                                        times = times != 0 ? times - 1 : times;
                                      });
                                    },
                                  ),
                                  Text(
                                    '${times}X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: 'lato',
                                    ),
                                  ),
                                  AddWidget(
                                    onPressed: () {
                                      setState(() {
                                        times = times + 1;
                                      });
                                    },
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      'Starts At  ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontFamily: 'lato',
                                      ),
                                    ),
                                    toolTipBuilder(
                                        'What time do you want set for your affirmation notification?')
                                  ],
                                ),
                              ),
                              Flexible(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RemoveWidget(
                                    onPressed: () {
                                      setState(() {
                                        startTime = subHour(startTime);
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      TimeOfDay? newTime = await showTimePicker(
                                          context: context,
                                          initialTime: startTime);
                                      if (newTime == null) return;
                                      setState(() => startTime = newTime);
                                    },
                                    child: Text(
                                      getformattedTime(startTime),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: 'lato',
                                      ),
                                    ),
                                  ),
                                  AddWidget(
                                    onPressed: () {
                                      setState(() {
                                        startTime = addHour(startTime);
                                      });
                                    },
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      'Ends At  ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontFamily: 'lato',
                                      ),
                                    ),
                                    toolTipBuilder(
                                        'At what time do you want your affirmations to stop?')
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RemoveWidget(
                                      onPressed: () {
                                        setState(() {
                                          endTime = subHour(endTime);
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        TimeOfDay? newTime =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: endTime);
                                        if (newTime == null) return;
                                        setState(() => endTime = newTime);
                                      },
                                      child: Text(
                                        getformattedTime(endTime),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontFamily: 'lato',
                                        ),
                                      ),
                                    ),
                                    AddWidget(
                                      onPressed: () {
                                        setState(() {
                                          endTime = addHour(endTime);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Repeat ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontFamily: 'lato',
                                    ),
                                  ),
                                  toolTipBuilder(
                                      "On what days would you like to see affirmations?")
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 2,
                                runSpacing: 3,
                                children: [
                                  for (int i = 0; i < days.length; i++)
                                    gradientPill(
                                        val: days[i],
                                        label: days[i].toUpperCase()),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
              LargeButton(
                title: "Save Changes",
                onPressed: onContinue,
              )
            ],
          ),
        ],
      ),
    );
  }

  Tooltip toolTipBuilder(String text) {
    return Tooltip(
      showDuration: const Duration(seconds: 20),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      triggerMode: TooltipTriggerMode.tap,
      textAlign: TextAlign.center,
      message: text,
      child: Icon(
        Icons.info_outline,
        color: Theme.of(context).colorScheme.tertiary,
        size: 18,
      ),
    );
  }

  InkWell gradientPill({required String val, required String label}) {
    return InkWell(
      onTap: () => toggleDaySelect(val),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: 50,
        height: 35,
        decoration: BoxDecoration(
          border: !selectedDays.contains(val)
              ? Border.all(
                  width: 1,
                  color: const Color.fromRGBO(31, 45, 65, 0.2),
                )
              : Border.all(
                  width: 1,
                  color: const Color.fromRGBO(251, 157, 63, 1),
                ),
          gradient: selectedDays.contains(val)
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 240, 245, 1),
                    Color.fromRGBO(251, 157, 63, 1),
                  ],
                  tileMode: TileMode.mirror,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

class RemoveWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const RemoveWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(31, 45, 65, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: const Icon(
          Icons.remove,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const AddWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(31, 45, 65, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: const Icon(
          Icons.add,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
