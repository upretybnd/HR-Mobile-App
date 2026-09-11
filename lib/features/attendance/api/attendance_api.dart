import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/attendance/model/attendance_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceApi {
  static Future<AttendanceModel> fetchAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.attendance),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return AttendanceModel.fromJson(jsonData);
    } else {
      debugPrint('Attendance API error: ${response.statusCode}');
      throw Exception('Failed to load attendance: ${response.statusCode}');
    }
  }

  // Api call for attendance check-in
  static Future<Map<String, dynamic>> postCheckIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.checkIn),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('Check-in success');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      debugPrint('Check-in error: ${response.body}');
      throw Exception('Failed to check in: ${response.statusCode}');
    }
  }

  // Api call for attendance check-out
  static Future<Map<String, dynamic>> postCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.checkOut),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('Check-out success');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      debugPrint('Check-out error: ${response.body}');
      throw Exception('Failed to check out: ${response.statusCode}');
    }
  }
}