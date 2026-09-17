
import 'dart:convert';

import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/department/model/department_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentApi {
  // get api for department
  static Future<DepartmentResponse> fetchDepartments() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.departments),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      return DepartmentResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load departments: ${response.statusCode}');
    }
  }

// post new department
  static Future<bool> postDepartments(
    final String name,
    final String description
  ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.departments),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name':name,
        'description':description
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Failed to create department: ${response.statusCode}');
    }
  }

// get department by id
  static Future<DepartmentModel> fetchDepartmentsById(
    final String id
  ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.departmentsId(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      return DepartmentModel.fromJson(jsonData['data'] ?? jsonData);
    } else {
      throw Exception('Failed to get department by id: ${response.statusCode}');
    }
  }

// put api for department by id
  static Future<DepartmentModel> updateDepartmentsById(
    final String id,
    final String name,
    final String description
  ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse(ApiEndpoints.departmentsId(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name':name,
        'description':description
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      return DepartmentModel.fromJson(jsonData['data'] ?? jsonData);
    } else {
      throw Exception('Failed to update department by id: ${response.statusCode}');
    }
  }

  // delete api for department by id
  static Future<bool> deleteDepartmentsById(
    final String id
  ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.delete(
      Uri.parse(ApiEndpoints.departmentsId(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Failed to delete department by id: ${response.statusCode}');
    }
  }
}