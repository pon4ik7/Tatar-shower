class RegisterRequest {
  final String login;
  final String password;
  final String language;
  final String? reason;
  final String frequencyType;
  final List<String>? customDays;
  final String experienceType;
  final int targetStreak;

  RegisterRequest({
    required this.login,
    required this.password,
    required this.language,
    this.reason,
    required this.frequencyType,
    this.customDays,
    required this.experienceType,
    required this.targetStreak,
  });

  Map<String, dynamic> toJson() => {
    "login": login,
    "password": password,
    "language": language,
    "reason": reason,
    "frequency_type": frequencyType,
    "custom_days": customDays,
    "experience_type": experienceType,
    "target_streak": targetStreak,
  };
}
