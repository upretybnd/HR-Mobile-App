
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/intern/model/interns_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InternsApi {
  // get api call for interns
  static Future<InternsModel> getInterns() async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.interns),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return InternsModel.fromJson(jsonData);
    } else {
      debugPrint('Intern API error: ${response.statusCode}');
      throw Exception('Failed to load interns: ${response.statusCode}');
    }
  }

  // post/convert api call for interns
  static Future<Map<String, dynamic>> convertInterns(
    final String id,
    final String departmentId,
    final String position,
    final String employeeType
  ) async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.internConvert(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "departmentId": departmentId,
        "position": position,
        "employeeType": employeeType
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonData;
    } else {
      debugPrint('Intern API error: ${response.statusCode}');
      throw Exception('Failed to convert intern: ${response.statusCode}');
    }
  }
}