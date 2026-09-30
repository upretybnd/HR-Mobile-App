
import 'dart:convert';

import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/employee/model/byEmail_model.dart';
import 'package:hr_management/features/employee/model/employee_grouped_model.dart';
import 'package:hr_management/features/employee/model/employee_id_model.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
import 'package:hr_management/features/employee/model/users_grouped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeApi {
  // get api for employee
  static Future<EmployeeModel> fetchEmployees() async {
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.employee),
      headers: {'Content-Type':'application/json',
      'Authorization':'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('employee api success');
    }
    final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
    return EmployeeModel.fromJson(jsonData);
  }

  // get api for grouped employees
  static Future<EmployeeGroupedResponse> fetchGroupedEmployees() async {
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.employeeGrouped),
      headers: {'Content-Type':'application/json',
      'Authorization':'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      return EmployeeGroupedResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch grouped employees: ${response.statusCode}');
    }
  }

  // get api for employee by id
  static Future<EmployeeIdResponse> fetchEmployeesById(
    final String id
  ) async {
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.employeeId(id)),
      headers: {'Content-Type':'application/json',
      'Authorization':'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      return EmployeeIdResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to get employee by id: ${response.statusCode}');
    }
  }

  // get api call to get users by email
  static Future<ByEmailModel> fetchUsersByEmail(
    final String email
  ) async {
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.byEmail(email)),
      headers: {'Content-Type':'application/json',
      'Authorization':'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      return ByEmailModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to get user by email: ${response.statusCode}');
    }
  }

  // get api call to get users by email
  static Future<UsersGroupedModel> fetchUsersByGrouped() async {
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.usersGrouped),
      headers: {'Content-Type':'application/json',
      'Authorization':'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      return UsersGroupedModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to get user by group: ${response.statusCode}');
    }
  }
}