import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatar_shower/models/shower_model.dart';

class ShowerLogStorage {
  static const _key = 'shower_logs';

  static Future<void> saveLog(ShowerLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingLogs = prefs.getStringList(_key) ?? [];

    final newLog = jsonEncode({
      'date': log.date.toIso8601String(),
      'total': log.totalDuration.inSeconds,
      'cold': log.coldDuration.inSeconds,
    });

    existingLogs.add(newLog);
    await prefs.setStringList(_key, existingLogs);
  }

  static Future<List<ShowerLog>> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList(_key) ?? [];

    return logs.map((str) {
      final json = jsonDecode(str);
      return ShowerLog(
        date: DateTime.parse(json['date']),
        totalDuration: Duration(seconds: json['total']),
        coldDuration: Duration(seconds: json['cold']),
      );
    }).toList();
  }
}
