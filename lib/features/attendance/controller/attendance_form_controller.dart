import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/attendance/api/attendance_api.dart';
import 'package:hr_management/features/attendance/controller/attendance_controller.dart';

class AttendanceFormController extends GetxController {
  final currentTime = DateTime.now().obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Update the time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Format time manually since intl is not installed
  String get formattedTime {
    final time = currentTime.value;
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';
    
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;

    return '$hour:$minute:$second $amPm';
  }

  String get formattedDate {
    final time = currentTime.value;
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    
    final weekday = weekdays[time.weekday - 1];
    final month = months[time.month - 1];
    
    return '$weekday, ${time.day} $month ${time.year}';
  }

  final isLoading = false.obs;

  Future<void> checkIn() async {
    try {
      isLoading.value = true;
      final response = await AttendanceApi.postCheckIn();
      final message = response['message'] ?? 'Checked in';
      
      // Try to refresh the list if the controller exists
      if (Get.isRegistered<AttendanceController>()) {
        await Get.find<AttendanceController>().fetchAttendance();
      }
      
      Get.back();
      Get.snackbar(
        'Success',
        '$message at $formattedTime',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      debugPrint('Check-in error: $e');
      Get.snackbar(
        'Error',
        'Failed to check in. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    try {
      isLoading.value = true;
      final response = await AttendanceApi.postCheckout();
      final message = response['message'] ?? 'Checked out';
      
      // Try to refresh the list if the controller exists
      if (Get.isRegistered<AttendanceController>()) {
        await Get.find<AttendanceController>().fetchAttendance();
      }
      
      Get.back();
      Get.snackbar(
        'Success',
        '$message at $formattedTime',
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
    } catch (e) {
      debugPrint('Check-out error: $e');
      Get.snackbar(
        'Error',
        'Failed to check out. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
