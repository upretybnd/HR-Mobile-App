import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/intern/api/interns_api.dart';
import 'package:hr_management/features/intern/model/interns_model.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/employee/controller/employee_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternsController extends GetxController {
  final isLoading = true.obs;
  final internsList = <Intern>[].obs;
  final errorMessage = ''.obs;
  final userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString('user_role') ?? '';
    fetchInterns();
  }

  Future<void> fetchInterns() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final InternsModel response = await InternsApi.getInterns();
      
      if (response.success) {
        internsList.assignAll(response.data);
      } else {
        if (userRole.value == 'EMPLOYEE') {
          errorMessage.value = 'Access Restricted\nYou do not have sufficient privileges to view the Interns directory. Please contact the HR department or an Administrator if you require access.';
        } else {
          errorMessage.value = response.message;
          Get.snackbar(
            'Error',
            errorMessage.value,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      debugPrint('Fetch Interns Error: $e');
      if (userRole.value == 'EMPLOYEE') {
        errorMessage.value = 'Access Restricted\nYou do not have sufficient privileges to view the Interns directory. Please contact the HR department or an Administrator if you require access.';
      } else {
        errorMessage.value = 'Failed to load interns. Please try again later.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> convertIntern(String id, String departmentId, String position, String employeeType) async {
    try {
      final response = await InternsApi.convertInterns(id, departmentId, position, employeeType);
      
      final bool isSuccess = response['success'] ?? false;
      final String message = response['message'] ?? 'Unknown error';

      if (isSuccess) {
        // Remove the converted intern from the local list instantly
        internsList.removeWhere((intern) => intern.id == id);
        internsList.refresh();

        Get.snackbar(
          'Success',
          'Intern successfully converted to employee!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );
        
        // Auto-refresh Employee page if it's already active in memory
        if (Get.isRegistered<EmployeeController>()) {
          Get.find<EmployeeController>().fetchEmployees();
        }
      } else {
        Get.snackbar(
          'Conversion Failed',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Convert Intern Error: $e');
      Get.snackbar(
        'Error',
        'Failed to convert intern. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 4),
      );
    }
  }
}

