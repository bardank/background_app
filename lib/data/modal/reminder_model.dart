import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 20)
class ReminderModel {
  ReminderModel({
    required this.id,
    required this.endTime,
    required this.startTime,
    required this.timesNo,
    required this.repeatDays,
    required this.enabled,
    required this.subCategory,
    required this.affirmationType,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  Time endTime;

  @HiveField(2)
  Time startTime;

  @HiveField(3)
  int timesNo;

  @HiveField(4)
  List<String> repeatDays;

  @HiveField(5)
  bool enabled;

  @HiveField(6)
  List<String> subCategory;

  @HiveField(7)
  List<String> affirmationType;

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        id: json["id"],
        endTime: Time.fromJson(json["endTime"]),
        startTime: Time.fromJson(json["startTime"]),
        timesNo: json["timesNo"],
        enabled: json["enabled"],
        repeatDays: List<String>.from(json["repeatDays"].map((x) => x)),
        subCategory: List<String>.from(json["subCategory"].map((x) => x)),
        affirmationType:
            List<String>.from(json["affirmationType"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "endTime": endTime.toJson(),
        "startTime": startTime.toJson(),
        "timesNo": timesNo,
        "enabled": enabled,
        "repeatDays": List<String>.from(repeatDays.map((x) => x)),
        "subCategory": List<String>.from(subCategory.map((x) => x)),
        "affirmationType": List<String>.from(subCategory.map((x) => x)),
      };
}

@HiveType(typeId: 21)
class Time {
  Time({
    required this.hour,
    required this.minute,
  });

  @HiveField(0)
  int hour;
  @HiveField(1)
  int minute;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        hour: json["hour"],
        minute: json["minute"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
}

enum Days { sun, mon, tue, wed, thu, fri, sat }
