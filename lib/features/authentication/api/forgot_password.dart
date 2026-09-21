
import 'dart:convert';

import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;

class ForgotPassword {
  static Future<void> postForgotPassword({required String email}) async{
final response = await http.post(
      Uri.parse(ApiEndpoints.forgotPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email":email
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request failed with status ${response.statusCode}');
    }
  }
}