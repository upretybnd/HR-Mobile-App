import 'dart:convert';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/authentication/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  // get api call for auth/me
  static Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.me),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      return UserModel.fromJson(decoded);
    } else {
      throw Exception('Request failed with status ${response.statusCode}');
    }
  }

  // put api call to update profile info
  static Future<void> editUser(
    final String firstName,
    final String lastName,
    final String phone
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse(ApiEndpoints.profile),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "firstName":firstName,
        "lastName":lastName,
        "phone":phone
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
    } else {
      throw Exception('Request failed with status ${response.statusCode}');
    }
  }
}