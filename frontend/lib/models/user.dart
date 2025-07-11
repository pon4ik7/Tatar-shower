import 'package:tatar_shower/models/schedule.dart';

// Valid model
class User {
  int id;
  String login;
  String password;
  Schedule schedule;

  User({
    required this.id,
    required this.login,
    required this.password,
    required this.schedule,
  });

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "Login": login,
      "Password": password,
      "Schedule": schedule.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as int,
      login: json['Login'] as String,
      password: json['Password'] as String,
      schedule: Schedule.fromJson(json['Schedule'] as Map<String, dynamic>),
    );
  }
}
