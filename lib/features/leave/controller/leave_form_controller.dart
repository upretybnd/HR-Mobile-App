import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/leave/api/leave_api.dart';
import 'package:hr_management/features/leave/controller/leave_controller.dart';
import 'package:hr_management/features/leave/model/leave_type_model.dart';

class LeaveFormController extends GetxController {
  final isLoading = false.obs;
  final leaveTypes = <LeaveTypeModel>[].obs;
  final selectedLeaveType = Rxn<LeaveTypeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchLeaveTypes();
  }

  Future<void> fetchLeaveTypes() async {
    try {
      isLoading.value = true;
      final response = await LeaveApi.fetchLeaveTypes();
      if (response.success) {
        leaveTypes.value = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching leave types: $e');
      Get.snackbar(
        'Error',
        'Could not load leave types.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedLeaveType(LeaveTypeModel? type) {
    selectedLeaveType.value = type;
  }

  // Form State
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final reasonController = TextEditingController();
  final isSubmitting = false.obs;

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  void pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      startDate.value = picked;
    }
  }

  void pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? startDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  Future<void> submitLeaveRequest() async {
    if (selectedLeaveType.value == null) {
      Get.snackbar('Error', 'Please select a leave type.', backgroundColor: Colors.red.withValues(alpha: 0.1), colorText: Colors.red);
      return;
    }
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar('Error', 'Please select start and end dates.', backgroundColor: Colors.red.withValues(alpha: 0.1), colorText: Colors.red);
      return;
    }
    if (reasonController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please provide a reason.', backgroundColor: Colors.red.withValues(alpha: 0.1), colorText: Colors.red);
      return;
    }

    try {
      isSubmitting.value = true;
      
      // format dates to ISO-8601
      final start = startDate.value!.toUtc().toIso8601String();
      final end = endDate.value!.toUtc().toIso8601String();

      final success = await LeaveApi.postLeaveRequest(
        selectedLeaveType.value!.id, // use the id from leavetype get api
        start,
        end,
        reasonController.text.trim(),
      );

      if (success) {
        if (Get.isRegistered<LeaveController>()) {
          await Get.find<LeaveController>().fetchLeaveRequests();
        }
        Get.back(); // close form
        Get.snackbar(
          'Success', 
          'Leave request submitted successfully.',
          backgroundColor: Colors.green.withValues(alpha: 0.1), 
          colorText: Colors.green,
        );
      }
    } catch (e) {
      debugPrint('Submit leave error: $e');
      Get.snackbar(
        'Error', 
        'Failed to submit leave request.',
        backgroundColor: Colors.red.withValues(alpha: 0.1), 
        colorText: Colors.red,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
