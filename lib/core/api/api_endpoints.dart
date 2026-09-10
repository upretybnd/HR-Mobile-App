
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_HOST'] ?? '';
  static String get register => '${baseUrl}auth/register';
  static String get login => '${baseUrl}auth/login';
  static String get employee => '${baseUrl}employees';
}