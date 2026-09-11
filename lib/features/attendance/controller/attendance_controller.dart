import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/attendance/api/attendance_api.dart';
import 'package:hr_management/features/attendance/model/attendance_model.dart';

class AttendanceController extends GetxController {
  final isLoading = false.obs;
  final attendanceRecords = <AttendanceRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      isLoading.value = true;
      final response = await AttendanceApi.fetchAttendance();
      if (response.success) {
        attendanceRecords.value = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      Get.snackbar(
        'Error',
        'Could not load attendance data.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper to format time from DateTime
  String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final local = dateTime.toLocal();
    int hour = local.hour;
    final minute = local.minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '${hour.toString().padLeft(2, '0')}:$minute $amPm';
  }

  // Get present count
  int get presentCount => attendanceRecords.where((r) => r.status == 'PRESENT' || r.status == 'ON_TIME').length;

  // Get absent count
  int get absentCount => attendanceRecords.where((r) => r.status == 'ABSENT').length;

  // Get late count
  int get lateCount => attendanceRecords.where((r) => r.status == 'LATE').length;

  // Check In
  Future<void> checkIn() async {
    try {
      final response = await AttendanceApi.postCheckIn();
      final message = response['message'] ?? 'Checked in';
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
      await fetchAttendance(); // refresh the list
    } catch (e) {
      debugPrint('Check-in error: $e');
      Get.snackbar(
        'Error',
        'Failed to check in. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  // Check Out
  Future<void> checkOut() async {
    try {
      final response = await AttendanceApi.postCheckout();
      final message = response['message'] ?? 'Checked out';
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
      await fetchAttendance(); // refresh the list
    } catch (e) {
      debugPrint('Check-out error: $e');
      Get.snackbar(
        'Error',
        'Failed to check out. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }
}
