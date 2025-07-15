import 'package:shared_preferences/shared_preferences.dart';

class UserStreakPreference {
  static const _key = 'desired_streak';

  static Future<void> saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, streak);
  }

  static Future<int?> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
