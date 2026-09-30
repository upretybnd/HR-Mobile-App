import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:hr_management/features/document/model/files_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

class FilesApi {
  // get api call to fetch files
  static Future<FilesModel> fetchFiles() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token');

    final response = await http.get(
      Uri.parse(ApiEndpoints.files),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return FilesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Request failed with status ${response.statusCode}');
    }
  }

  // post api call to upload files using multipart/form-data
  static Future<Map<String, dynamic>> uploadFile(String filePath) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token');

    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await dio.post(
      ApiEndpoints.upload,
      data: formData,
      options: Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  }

  // delete api call to delete files
  static Future<Map<String, dynamic>> deleteFile(String id) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token');

    final dio = Dio();

    final response = await dio.delete(
      ApiEndpoints.deleteFiles(id),
      options: Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  }

  /// Downloads a file to the given [savePath] using Dio.
  /// Sends both the Authorization header AND the download token (in the URL query param).
  static Future<void> downloadFile({
    required String downloadUrl,
    required String savePath,
    void Function(int received, int total)? onProgress,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token');

    // Build the full URL
    String fullUrl = downloadUrl;
    if (downloadUrl.startsWith('/')) {
      final String origin = Uri.parse(ApiEndpoints.baseUrl).origin;
      fullUrl = origin + downloadUrl;
    }

    final dio = Dio();
    await dio.download(
      fullUrl,
      savePath,
      options: Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
      onReceiveProgress: onProgress,
    );
  }
}