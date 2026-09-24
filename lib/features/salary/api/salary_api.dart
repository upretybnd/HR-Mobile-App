import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/salary/model/payslip_model.dart';
import 'package:hr_management/features/salary/model/salary_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SalaryApi {
  // post api call to post structure for an eployee
  static Future<bool> postSalaryStructure(
    final String employeeId,
    final num baseSalary,
    final num allowances,
    final num deductions
  ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.salary),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "employeeId": employeeId,
        "baseSalary": baseSalary,
        "allowances": allowances,
        "deductions": deductions
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      
      debugPrint('Salary API error: ${response.statusCode}');
      throw Exception('Failed to post salary structure: ${response.statusCode}');
    }
  }

  // get api call to get salary structure of an employee
  static Future<SalaryModel> getSalaryStructure(
    final String employeeId,
  ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.salaryStructure(employeeId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      return SalaryModel.fromJson(decoded);
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      
      debugPrint('Salary API error: ${response.statusCode}');
      throw Exception('Failed to get salary structure: ${response.statusCode}');
    }
  }

  // post api call to generate salary slip
  static Future<bool> generatePayroll(
    final int month,
    final int year
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.payrollGenerate),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "month": month,
        "year": year
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      
      debugPrint('Payroll Generate API error: ${response.statusCode}');
      throw Exception('Failed to generate payroll: ${response.statusCode}');
    }
  }

  // get api call to get the payslip
  static Future<List<PayslipData>> fetchPayslip() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.slip),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      final payslipModel = PayslipModel.fromJson(decoded);
      return payslipModel.data;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      
      debugPrint('payslip Get API error: ${response.statusCode}');
      throw Exception('Failed to get payslip: ${response.statusCode}');
    }
  }

  // patch api call to edit/update the payslip status
  static Future<void> patchPayslip(
    final String id,
    final String status
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.patch(
      Uri.parse(ApiEndpoints.slipId(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "status":status
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      
      debugPrint('payslip patch API error: ${response.statusCode}');
      throw Exception('Failed to patch payslip: ${response.statusCode}');
    }
  }
}