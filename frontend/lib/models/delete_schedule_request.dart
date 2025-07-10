//TODO: Verify if the model valid
class DeleteScheduleRequest {
  String day;

  DeleteScheduleRequest({required this.day});

  Map<String, dynamic> toJson() {
    return {"day": day};
  }

  factory DeleteScheduleRequest.fromJson(Map<String, dynamic> json) {
    return DeleteScheduleRequest(day: json['day'] as String);
  }
}
