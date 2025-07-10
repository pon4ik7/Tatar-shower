class CompleteShowerRequest {
  String day;
  String time;

  CompleteShowerRequest({required this.day, required this.time});

  Map<String, dynamic> toJson() {
    return {"day": day, "time": time};
  }

  factory CompleteShowerRequest.fromJson(Map<String, dynamic> json) {
    return CompleteShowerRequest(
      day: json['day'] as String,
      time: json['time'] as String,
    );
  }
}
