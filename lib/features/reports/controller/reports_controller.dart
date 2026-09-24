import 'package:get/get.dart';
import 'package:hr_management/features/reports/api/report_api.dart';
import 'package:hr_management/features/reports/model/reports_model.dart';
import 'package:hr_management/features/employee/controller/employee_controller.dart';
import 'package:hr_management/features/intern/controller/interns_controller.dart';
import 'package:hr_management/features/leave/controller/leave_controller.dart';
import 'package:hr_management/features/attendance/controller/attendance_controller.dart';
import 'package:flutter/material.dart';

class ReportsController extends GetxController {
  var isLoading = true.obs;
  var reports = <ReportData>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
    _initStats();
  }

  void _initStats() {
    // Put controllers to ensure they exist and fetch their data
    Get.put(EmployeeController());
    Get.put(InternsController());
    Get.put(LeaveController());
    Get.put(AttendanceController());
  }

  // Reactive getters that automatically update when the respective controller's list updates
  String get totalEmployeesCount => Get.find<EmployeeController>().employees.length.toString();
  String get totalInternsCount => Get.find<InternsController>().internsList.length.toString();
  
  String get pendingLeavesCount {
    final leaveRecords = Get.find<LeaveController>().leaveRecords;
    return leaveRecords.where((leave) => leave.status.toUpperCase() == 'PENDING').length.toString();
  }

  String get attendanceRate {
    final attendance = Get.find<AttendanceController>().attendanceRecords;
    if (attendance.isEmpty) return '0%';
    final present = attendance.where((record) => record.status.toUpperCase() == 'PRESENT').length;
    final rate = (present / attendance.length) * 100;
    return '${rate.toStringAsFixed(1)}%';
  }

  String get internEndDatesCount {
    final interns = Get.find<InternsController>().internsList;
    // Approximating "End Dates" approaching logic: e.g. active interns (or placeholder if no end date exists)
    // For now, returning active interns as a metric, or just '0' if no explicit logic. We will return active interns count:
    return interns.where((intern) => intern.isActive).length.toString();
  }

  Future<void> fetchReports() async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedReports = await ReportApi.fetchReport();
      reports.assignAll(fetchedReports);
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> postReport(String type, String format) async {
    try {
      await ReportApi.postReport(type, format);
      await fetchReports();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
