import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hr_management/core/api/api_endpoints.dart';

class CreateAccountApi {
  static Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      }),
    );

    debugPrint('Register Response [${response.statusCode}]: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Registration failed with status ${response.statusCode}');
    }

    return;
  }
}
