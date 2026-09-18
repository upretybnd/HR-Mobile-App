import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/leave/api/leave_api.dart';
import 'package:hr_management/features/leave/model/leave_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveController extends GetxController {
  final isLoading = false.obs;
  final leaveRecords = <LeaveRecord>[].obs;
  final userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await _loadUserRole();
    fetchLeaveRequests();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString('user_role') ?? '';
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

  Future<void> updateLeaveStatus(String id, String status) async {
    try {
      await LeaveApi.updateLeaveRequest(id, status);
      await fetchLeaveRequests(); // Refresh the list
      
      Get.snackbar(
        'Success',
        'Leave request marked as $status',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error updating leave status: $e');
      Get.snackbar(
        'Error',
        'Failed to update leave status.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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