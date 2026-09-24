import 'dart:convert';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/reports/model/reports_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportApi {
  // post api call to post reports
  static Future<bool> postReport(final String type, final String format) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    String url = ApiEndpoints.reports;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"type": type, "format": format}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // final jsonData = jsonDecode(response.body) as Map<String,dynamic>;
      return true;
    } else {
      try {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {
        // If it's not JSON, fall back to the generic message below
      }
      throw Exception('Failed to post report. Status: ${response.statusCode}');
    }
  }

  // get api call to get reports
  static Future<List<ReportData>> fetchReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    String url = ApiEndpoints.getReports;
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      final ReportsModel reportsModel = ReportsModel.fromJson(jsonData);
      return reportsModel.data;
    } else {
      try {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        if (errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      } catch (_) {}
      throw Exception('Failed to fetch reports. Status: ${response.statusCode}');
    }
  }
}
