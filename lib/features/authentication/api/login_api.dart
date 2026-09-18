import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Login failed with status ${response.statusCode}');
    }
    final jsonData = jsonDecode(response.body);
    final token = jsonData['data']['accessToken'];
    final role = jsonData['data']['user']['role'];
    
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      if (role != null) {
        await prefs.setString('user_role', role);
      }
      debugPrint("Token and Role saved successfully!");
    } else {
      debugPrint("Warning: Token was null in the response.");
    }

    return;
  }
}