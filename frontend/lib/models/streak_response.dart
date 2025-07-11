// models/streak_response.dart
class StreakResponse {
  final int currentStreak;
  final String? lastCompleted;

  StreakResponse({required this.currentStreak, this.lastCompleted});

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      currentStreak: json['current_streak'] ?? 0,
      lastCompleted: json['last_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'current_streak': currentStreak, 'last_completed': lastCompleted};
  }
}
