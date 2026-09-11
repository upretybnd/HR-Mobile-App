
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_HOST'] ?? '';
  static String get register => '${baseUrl}auth/register';
  static String get login => '${baseUrl}auth/login';
  static String get employee => '${baseUrl}employees';
  static String get leaveType => '${baseUrl}leave-types';
  static String get leaveRequest => '${baseUrl}leave-requests';
  static String get attendance => '${baseUrl}attendance';
  static String get checkIn =>'${baseUrl}attendance/check-in';
  static String get checkOut =>'${baseUrl}attendance/check-out';
}