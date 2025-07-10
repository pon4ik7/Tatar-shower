//TODO: Verify if the model valid
class UpdateScheduleRequest {
  String day;
  List<String> tasks;

  UpdateScheduleRequest({required this.day, required this.tasks});

  Map<String, dynamic> toJson() {
    return {"day": day, "tasks": tasks};
  }

  factory UpdateScheduleRequest.fromJson(Map<String, dynamic> json) {
    return UpdateScheduleRequest(
      day: json['day'] as String,
      tasks: (json['tasks'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}
