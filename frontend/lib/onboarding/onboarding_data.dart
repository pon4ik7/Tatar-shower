import 'package:flutter/material.dart';

class OnboardingData extends ChangeNotifier {
  String? login;
  String? password;
  String language = 'en';
  bool notifications = false;
  String? reason;
  String frequencyType = 'everyday';
  List<String>? customDays = [];
  final Map<String, String> scheduleTimes = {};
  String experienceType = 'first_time';
  int targetStreak = 3;

  // methods for settings and notification
  void setLogin(String v) {
    login = v;
    notifyListeners();
  }

  void setPassword(String v) {
    password = v;
    notifyListeners();
  }

  void setLanguage(String v) {
    language = v;
    notifyListeners();
  }

  void setNotifications(bool v) {
    notifications = v;
    notifyListeners();
  }

  void setReason(String? v) {
    reason = v;
    notifyListeners();
  }

  void setFrequencyType(String v) {
    frequencyType = v;
    notifyListeners();
  }

  void setCustomDays(List<String>? v) {
    customDays = v;
    notifyListeners();
  }

  void setExperienceType(String v) {
    experienceType = v;
    notifyListeners();
  }

  void setTargetStreak(int v) {
    targetStreak = v;
    notifyListeners();
  }

  void setTimeForDay(String day, String time) {
    scheduleTimes[day] = time;
    notifyListeners();
  }
}
