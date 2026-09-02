import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/core/api/api_endpoints.dart';

class CreateAccountApi {
  static Future<void> registerUser({
    required String name,
    required String email,
    required String department,
    required String password,
  }) async {
    await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'department': department,
        'password': password,
      }),
    );
    
    return;
  }
}
