import 'dart:convert';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/announcement/model/announcement_id_model.dart';
import 'package:hr_management/features/announcement/model/announcement_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementApi {
  // fetch announcments
  static Future<AnnouncementResponse> getAnnouncement() async{
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.announcement),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token'
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      return AnnouncementResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  // fetch announcments by id
  static Future<AnnouncementIdModel> getAnnouncementId(
    final String id
  ) async{
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.announcementId(id)),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token'
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      final announcementResponse = AnnouncementIdResponse.fromJson(jsonData);
      return announcementResponse.data;
    } else {
      throw Exception('Failed to load announcement');
    }
  }

  // post announcments 
  static Future<AnnouncementIdModel> postAnnouncement(
    final String title,
    final String content,
    final String priority,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.announcement),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "title": title,
        "content": content,
        "priority": priority,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final announcementResponse = AnnouncementIdResponse.fromJson(jsonData);
      return announcementResponse.data;
    } else {
      throw Exception('Failed to post announcement');
    }
  }

  // delete announcement
  static Future<AnnouncementIdModel> deleteAnnouncementId(
    final String id
  ) async{
    final prefs =await SharedPreferences.getInstance();
    final token =prefs.getString('auth_token');

    final response = await http.delete(
      Uri.parse(ApiEndpoints.announcementId(id)),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token'
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData =jsonDecode(response.body) as Map<String,dynamic>;
      final announcementResponse = AnnouncementIdResponse.fromJson(jsonData);
      return announcementResponse.data;
    } else {
      throw Exception('Failed to load announcement');
    }
  }

  // put/update announcement
  static Future<AnnouncementIdModel> updateAnnouncementId(
    final String id,
    final String title,
    final String content,
    final String priority,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse(ApiEndpoints.announcementId(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "title": title,
        "content": content,
        "priority": priority,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final announcementResponse = AnnouncementIdResponse.fromJson(jsonData);
      return announcementResponse.data;
    } else {
      throw Exception('Failed to update announcement');
    }
  }
}