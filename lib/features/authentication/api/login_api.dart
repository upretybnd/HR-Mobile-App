import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  // post api for login
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
      String errorMsg = 'Login failed with status ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          errorMsg = errorData['message'];
        }
      } catch (_) {}
      throw Exception(errorMsg);
    }
    final jsonData = jsonDecode(response.body);
    final token = jsonData['data']['accessToken'];
    final refreshToken = jsonData['data']['refreshToken'];
    final role = jsonData['data']['user']['role'];
    
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      
      if (refreshToken != null) {
        await prefs.setString('refresh_token', refreshToken);
      }
      
      if (role != null) {
        await prefs.setString('user_role', role);
      }
      debugPrint("Token, Refresh Token, and Role saved successfully!");
    } else {
      debugPrint("Warning: Token was null in the response.");
    }

    return;
  }

// post api for logout 
  static Future<void> userLogout(String authToken, String refreshToken) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.logout),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Logout failed with status ${response.statusCode}');
    }
  }
}