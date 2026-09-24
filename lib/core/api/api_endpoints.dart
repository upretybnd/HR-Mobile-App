
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_HOST'] ?? '';
  static String get register => '${baseUrl}auth/register';
  static String get login => '${baseUrl}auth/login';
  static String get logout =>'${baseUrl}auth/logout';
  static String get forgotPassword =>'${baseUrl}auth/forgot-password';
  static String get verifyEmail =>'${baseUrl}auth/verify-email';
  static String get resendVerification =>'${baseUrl}auth/resend-verification';
  static String get me =>'${baseUrl}auth/me';
  static String get profile =>'${baseUrl}auth/profile';

  static String get employee => '${baseUrl}employees';
  static String get employeeGrouped => '${baseUrl}employees/grouped';
  static String employeeId(String id) => '${baseUrl}employees/$id';

  static String get leaveType => '${baseUrl}leave-types';
  static String get leaveRequest => '${baseUrl}leave-requests';
  static String patchLeaveRequest(String id) => '${baseUrl}leave-requests/$id';

  static String get attendance => '${baseUrl}attendance';
  static String get checkIn =>'${baseUrl}attendance/check-in';
  static String get checkOut =>'${baseUrl}attendance/check-out';
  static String get flags =>'${baseUrl}attendance/flags';
  static String  resolveFlags(String id) =>'${baseUrl}attendance/flags/$id/resolve';

  static String get announcement =>'${baseUrl}announcements';
  static String announcementId(String id) => '${baseUrl}announcements/$id';
  static String archive(String id) => '${baseUrl}announcements/$id/archive';
  static String unarchive(String id) => '${baseUrl}announcements/$id/unarchive';
  static String attachments(String id) => '${baseUrl}announcements/$id/attachments';

  static String get departments => '${baseUrl}departments';
  static String departmentsId(String id) => '${baseUrl}departments/$id';

  static String get chat => '${baseUrl}chat/rooms';
  static String chatRoom(String id) => '${baseUrl}chat/rooms/$id/messages';
  static String chatMembers(String id) => '${baseUrl}chat/rooms/$id/members';
  static String chatMembersRemove(String id) => '${baseUrl}chat/rooms/$id/members/$id';

  static String get interns => '${baseUrl}interns';
  static String internConvert(String id) => '${baseUrl}interns/$id/convert';

  static String get reports => '${baseUrl}reports/generate';
  static String get getReports => '${baseUrl}reports';

  static String get salary => '${baseUrl}payroll/salary';
  static String salaryStructure(String id) => '${baseUrl}payroll/salary/$id';
  static String get payrollGenerate => '${baseUrl}payroll/generate';
  static String get slip => '${baseUrl}payroll/payslips';
  static String slipId(String id) => '${baseUrl}payroll/payslips/$id/status';
}