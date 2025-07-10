import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tatar_shower/models/auth_request.dart';
import 'package:tatar_shower/models/complete_schower_request.dart';
import 'package:tatar_shower/models/delete_schedule_request.dart';
import 'package:tatar_shower/models/message_response.dart';
import 'package:tatar_shower/models/update_schedule_request.dart';

import '../models/schedule.dart';

class ApiService {
  static const String _baseUrl = "http://localhost:8080/api";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<MessageResponse> registerUser(AuthRequest request) async {
    final url = Uri.parse("$_baseUrl/register");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      String? authHeader = response.headers['authorization'];
      if (authHeader != null && authHeader.startsWith("Bearer ")) {
        String token = authHeader.substring(7);
        await _secureStorage.write(key: "jwtToken", value: token);
      }
      final Map<String, dynamic> respJson = jsonDecode(response.body);
      return MessageResponse.fromJson(respJson);
    } else {
      throw Exception(
        "Failed to register: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<MessageResponse> signInUser(AuthRequest request) async {
    final url = Uri.parse("$_baseUrl/signin");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      String? authHeader = response.headers['authorization'];
      if (authHeader != null && authHeader.startsWith("Bearer ")) {
        String token = authHeader.substring(7);
        await _secureStorage.write(key: "jwtToken", value: token);
      }
      final Map<String, dynamic> respJson = jsonDecode(response.body);
      return MessageResponse.fromJson(respJson);
    } else {
      throw Exception(
        "Failed to sign in: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<Schedule> getAllSchedules() async {
    final url = Uri.parse("$_baseUrl/user/schedules");
    String? token = await _secureStorage.read(key: "jwtToken");
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> respJson = jsonDecode(response.body);
      return Schedule.fromJson(respJson);
    } else {
      throw Exception(
        "Failed to load schedules: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<MessageResponse> updateSchedule(UpdateScheduleRequest request) async {
    final url = Uri.parse("$_baseUrl/user/schedules");
    String? token = await _secureStorage.read(key: "jwtToken");
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final body = jsonEncode(request.toJson());
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> respJson = jsonDecode(response.body);
      return MessageResponse.fromJson(respJson);
    } else {
      throw Exception(
        "Failed to update schedule: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<MessageResponse> deleteSchedule(DeleteScheduleRequest request) async {
    final url = Uri.parse("$_baseUrl/user/schedules");
    String? token = await _secureStorage.read(key: "jwtToken");
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final body = jsonEncode(request.toJson());
    final http.Request req = http.Request("DELETE", url);
    req.headers.addAll(headers);
    req.body = body;
    final http.StreamedResponse streamedResponse = await req.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> respJson = jsonDecode(response.body);
      return MessageResponse.fromJson(respJson);
    } else {
      throw Exception(
        "Failed to delete schedule: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<MessageResponse> completeShower(CompleteShowerRequest request) async {
    final url = Uri.parse("$_baseUrl/user/shower/completed");
    String? token = await _secureStorage.read(key: "jwtToken");
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> respJson = jsonDecode(response.body);
      return MessageResponse.fromJson(respJson);
    } else {
      throw Exception(
        "Failed to complete action: ${response.statusCode} ${response.body}",
      );
    }
  }
}
