class Schedule {
  List<String> monday;
  List<bool> mondayDone;
  List<String> tuesday;
  List<bool> tuesdayDone;
  List<String> wednesday;
  List<bool> wednesdayDone;
  List<String> thursday;
  List<bool> thursdayDone;
  List<String> friday;
  List<bool> fridayDone;
  List<String> saturday;
  List<bool> saturdayDone;
  List<String> sunday;
  List<bool> sundayDone;

  Schedule({
    required this.monday,
    required this.mondayDone,
    required this.tuesday,
    required this.tuesdayDone,
    required this.wednesday,
    required this.wednesdayDone,
    required this.thursday,
    required this.thursdayDone,
    required this.friday,
    required this.fridayDone,
    required this.saturday,
    required this.saturdayDone,
    required this.sunday,
    required this.sundayDone,
  });

  Map<String, dynamic> toJson() {
    return {
      "Monday": monday,
      "MondayDone": mondayDone,
      "Tuesday": tuesday,
      "TuesdayDone": tuesdayDone,
      "Wednesday": wednesday,
      "WednesdayDone": wednesdayDone,
      "Thursday": thursday,
      "ThursdayDone": thursdayDone,
      "Friday": friday,
      "FridayDone": fridayDone,
      "Saturday": saturday,
      "SaturdayDone": saturdayDone,
      "Sunday": sunday,
      "SundayDone": sundayDone,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    List<dynamic> mondayList = json['Monday'] ?? [];
    List<dynamic> mondayDoneList = json['MondayDone'] ?? [];
    List<dynamic> tuesdayList = json['Tuesday'] ?? [];
    List<dynamic> tuesdayDoneList = json['TuesdayDone'] ?? [];
    List<dynamic> wedList = json['Wednesday'] ?? [];
    List<dynamic> wedDoneList = json['WednesdayDone'] ?? [];
    List<dynamic> thuList = json['Thursday'] ?? [];
    List<dynamic> thuDoneList = json['ThursdayDone'] ?? [];
    List<dynamic> friList = json['Friday'] ?? [];
    List<dynamic> friDoneList = json['FridayDone'] ?? [];
    List<dynamic> satList = json['Saturday'] ?? [];
    List<dynamic> satDoneList = json['SaturdayDone'] ?? [];
    List<dynamic> sunList = json['Sunday'] ?? [];
    List<dynamic> sunDoneList = json['SundayDone'] ?? [];

    return Schedule(
      monday: mondayList.map((e) => e as String).toList(),
      mondayDone: mondayDoneList.map((e) => e as bool).toList(),
      tuesday: tuesdayList.map((e) => e as String).toList(),
      tuesdayDone: tuesdayDoneList.map((e) => e as bool).toList(),
      wednesday: wedList.map((e) => e as String).toList(),
      wednesdayDone: wedDoneList.map((e) => e as bool).toList(),
      thursday: thuList.map((e) => e as String).toList(),
      thursdayDone: thuDoneList.map((e) => e as bool).toList(),
      friday: friList.map((e) => e as String).toList(),
      fridayDone: friDoneList.map((e) => e as bool).toList(),
      saturday: satList.map((e) => e as String).toList(),
      saturdayDone: satDoneList.map((e) => e as bool).toList(),
      sunday: sunList.map((e) => e as String).toList(),
      sundayDone: sunDoneList.map((e) => e as bool).toList(),
    );
  }

  factory Schedule.empty() {
    return Schedule(
      monday: [],
      mondayDone: [],
      tuesday: [],
      tuesdayDone: [],
      wednesday: [],
      wednesdayDone: [],
      thursday: [],
      thursdayDone: [],
      friday: [],
      fridayDone: [],
      saturday: [],
      saturdayDone: [],
      sunday: [],
      sundayDone: [],
    );
  }
}
