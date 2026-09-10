
import 'dart:convert';

import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeApi {
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
}