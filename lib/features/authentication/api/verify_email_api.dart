
import 'dart:convert';

import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;

class VerifyEmailApi {
  static Future<void> postVerifyEmail({required String token}) async{
final response = await http.post(
      Uri.parse(ApiEndpoints.verifyEmail),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token":token
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Login failed with status ${response.statusCode}');
    }
  }
}