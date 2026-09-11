import 'dart:convert';
import 'package:hr_management/features/leave/model/leave_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/leave/model/leave_type_model.dart';

class LeaveApi {
  // api to get all leave-request types
  static Future<LeaveTypeResponse> fetchLeaveTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.leaveType),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      return LeaveTypeResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load leave types: ${response.statusCode}');
    }
  }

  // Api to post leave request
  static Future<bool> postLeaveRequest(
    String leaveTypeId,
    String dateFrom,
    String dateTo,
    String reason,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.leaveRequest),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'leaveTypeId': leaveTypeId,
        'from': dateFrom,
        'to': dateTo,
        'reason': reason,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Failed to submit leave request: ${response.body}');
    }
  }

  // Api to get leave requests
  static Future<LeaveModel> fetchLeaveRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.leaveRequest),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return LeaveModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch leave request: ${response.statusCode}');
    }
  }
}
