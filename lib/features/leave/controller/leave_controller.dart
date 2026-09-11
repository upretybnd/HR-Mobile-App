import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/leave/api/leave_api.dart';
import 'package:hr_management/features/leave/model/leave_model.dart';

class LeaveController extends GetxController {
  final isLoading = false.obs;
  final leaveRecords = <LeaveRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    try {
      isLoading.value = true;
      final response = await LeaveApi.fetchLeaveRequest();
      if (response.success) {
        leaveRecords.value = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching leave requests: $e');
      Get.snackbar(
        'Error',
        'Could not load leave history.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  int get pendingCount => leaveRecords.where((r) => r.status.toUpperCase() == 'PENDING').length;
  
  int get approvedCount => leaveRecords.where((r) => r.status.toUpperCase() == 'APPROVED').length;
}
