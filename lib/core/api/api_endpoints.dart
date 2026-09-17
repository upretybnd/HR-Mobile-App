
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_HOST'] ?? '';
  static String get register => '${baseUrl}auth/register';
  static String get login => '${baseUrl}auth/login';

  static String get employee => '${baseUrl}employees';
  static String get employeeGrouped => '${baseUrl}employees/grouped';
  static String employeeId(String id) => '${baseUrl}employees/$id';

  static String get leaveType => '${baseUrl}leave-types';
  static String get leaveRequest => '${baseUrl}leave-requests';
  static String patchLeaveRequest(String id) => '${baseUrl}leave-requests/$id';

  static String get attendance => '${baseUrl}attendance';
  static String get checkIn =>'${baseUrl}attendance/check-in';
  static String get checkOut =>'${baseUrl}attendance/check-out';

  static String get announcement =>'${baseUrl}announcements';
  static String announcementId(String id) => '${baseUrl}announcements/$id';

  static String get departments => '${baseUrl}departments';
  static String departmentsId(String id) => '${baseUrl}departments/$id';
}