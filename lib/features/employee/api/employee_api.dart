
import 'dart:convert';

import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/employee/model/employee_grouped_model.dart';
import 'package:hr_management/features/employee/model/employee_id_model.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
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
  static Future<EmployeeGroupedItemModel> fetchGroupedEmployees() async {
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.employeeGrouped),
      headers: {'Content-Type':'application/json',
      'Authorization':'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('grouped employee api success');
    }
    final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
    return EmployeeGroupedItemModel.fromJson(jsonData);
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
}