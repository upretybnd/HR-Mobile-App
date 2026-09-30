import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/recruitment/model/applications_model.dart';
import 'package:hr_management/features/recruitment/model/recruitment_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecruitmentApi {
  // get api call to fetch jobs
    static Future<RecruitmentModel> fetchRecruitment() async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.recruitment),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return RecruitmentModel.fromJson(jsonData);
    } else {
      debugPrint('recruitment API error: ${response.statusCode}');
      throw Exception('Failed to load recruitment: ${response.statusCode}');
    }
  }

  // get api call to fetch application/applicants
    static Future<ApplicationsModel> fetchApplications() async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.applications),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return ApplicationsModel.fromJson(jsonData);
    } else {
      debugPrint('application API error: ${response.statusCode}');
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  }

  // post api call to create jobs
    static Future<void> postJobs(
      final String departmentId,
      final String title,
      final String description,
      final String department,
      final String location,
      final String type,
      final String salaryMin,
      final String salaryMax,
    ) async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.recruitment),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "departmentId":departmentId,
        "title":title,
        "description":description,
        "department":department,
        "location":location,
        "type":type,
        "salaryMin": int.tryParse(salaryMin) ?? 0,
        "salaryMax": int.tryParse(salaryMax) ?? 0
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
    } else {
      debugPrint('application API error: ${response.statusCode}');
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  }

  // put api call for updating the job applications
    static Future<void> updateJobs(
      final String id,
      final String title,
      final String description,
      final String status
    ) async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse(ApiEndpoints.jobs(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "id":id,
        "title":title,
        "description":description,
        "status":status,
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
    } else {
      debugPrint('application API error: ${response.statusCode}');
      throw Exception('Failed to load applications: ${response.statusCode}');
    }
  }

  // post api call to apply the job applications
  static Future<void> applyJob({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? coverLetter,
    File? resume,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final uri = Uri.parse(ApiEndpoints.apply(id));
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Text fields
    request.fields['firstName'] = firstName;
    request.fields['lastName'] = lastName;
    request.fields['email'] = email;
    if (phone != null && phone.isNotEmpty) {
      request.fields['phone'] = phone;
    }
    if (coverLetter != null && coverLetter.isNotEmpty) {
      request.fields['coverLetter'] = coverLetter;
    }

    // File field
    if (resume != null) {
      String ext = resume.path.split('.').last.toLowerCase();
      String mimeType = 'application/octet-stream';
      if (ext == 'pdf') {
        mimeType = 'application/pdf';
      } else if (ext == 'doc') {
        mimeType = 'application/msword';
      } else if (ext == 'docx') {
        mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          'resume',
          resume.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Applied successfully: ${response.body}');
    } else {
      debugPrint('apply job error: ${response.statusCode} ${response.body}');
      throw Exception(
        'Failed to apply for job: ${response.statusCode} ${response.body}',
      );
    }
  }

    // patch api call to create jobs
    static Future<void> patchJobStatus(
      final String id,
      final String status
    ) async{
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.patch(
      Uri.parse(ApiEndpoints.jobStatus(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "id":id,
        "status":status
      })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // success
    } else {
      debugPrint('patch job status API error: ${response.statusCode}');
      throw Exception('Failed to update job status: ${response.statusCode}');
    }
  }
}