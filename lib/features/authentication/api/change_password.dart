import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordApi {
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.changePassword),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    debugPrint('change password Response [${response.statusCode}]: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Change Password failed with status ${response.statusCode}');
    }

    return;
  }
}
