// Valid request for complete flag
class CompleteShowerRequest {
  String day;
  String task;
  String time;
  String coldTime;

  CompleteShowerRequest({
    required this.day,
    required this.task,
    required this.time,
    required this.coldTime,
  });

  Map<String, dynamic> toJson() {
    return {"day": day, "task": task, "time": time, "coldTime": coldTime};
  }

  factory CompleteShowerRequest.fromJson(Map<String, dynamic> json) {
    return CompleteShowerRequest(
      day: json['day'] as String,
      task: json['task'] as String,
      time: json['time'] as String,
      coldTime: json['coldTime'] as String,
    );
  }
}
