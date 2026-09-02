
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_HOST']??'';
  static String register = '${baseUrl}auth/register';
  static String login = '${baseUrl}auth/login';
}