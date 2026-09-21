
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/messages/model/chat_room_id_model.dart';
import 'package:hr_management/features/messages/model/chat_room_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomApi {
  // API call to create chat room
 static Future<String> createChatRoom(
  final String name,
  final String type,
  final String description
 ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.chat),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name":name,
        "type":type,
        "description":description
      })
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('create chat room success');
      try {
        final json = jsonDecode(response.body);
        return json['data']['id']?.toString() ?? '';
      } catch (e) {
        return '';
      }
    } else {
      debugPrint('create chat room error: ${response.body}');
      throw Exception('Failed to create chat room: ${response.statusCode}');
    }
  }

  // API call for chat room
 static Future<ChatRoomResponse> fetchChatRoom() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.chat),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('Fetch chat room success');
      return ChatRoomResponse.fromJson(jsonDecode(response.body));
    } else {
      debugPrint('Fetch chat room error: ${response.body}');
      throw Exception('Failed to fetch chat room: ${response.statusCode}');
    }
  }

  // API call for chat room get by Id
 static Future<ChatRoomIdResponse> getChatRoom(
  final String id
 ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.chatRoom(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('Fetch chat room by ID success');
      return ChatRoomIdResponse.fromJson(jsonDecode(response.body));
    } else {
      debugPrint('Fetch chat room by ID error: ${response.body}');
      throw Exception('Failed to fetch chat room: ${response.statusCode}');
    }
  }

  // API call for chat room post by Id
 static Future<void> postChatRoom(
  final String id,
  final String content,
 ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.chatRoom(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "content": content,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('post chat room by ID success');
      return;
    } else {
      debugPrint('post chat room by ID error: ${response.body}');
      throw Exception('Failed to post chat room: ${response.statusCode}');
    }
  }

  // API call for chat room post by Id
 static Future<void> postChatMembers(
  final String id,
  final String userId,
 ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse(ApiEndpoints.chatMembers(id)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "userId":userId
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('post chat members by ID success');
      return;
    } else {
      debugPrint('post chat members by ID error: ${response.body}');
      throw Exception('Failed to post chat members: ${response.statusCode}');
    }
  }

  // API call for chat room members delete  by Id
 static Future<void> deleteChatMembers(
  final String id,
  final String memberId,
 ) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.delete(
      Uri.parse('${ApiEndpoints.chatMembers(id)}/$memberId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('delete chat members by ID success');
      return;
    } else {
      debugPrint('delete chat members by ID error: ${response.body}');
      throw Exception('Failed to delete chat members: ${response.statusCode}');
    }
  }
}