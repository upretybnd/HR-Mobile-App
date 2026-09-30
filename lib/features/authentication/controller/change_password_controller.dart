import 'package:hr_management/features/authentication/api/change_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  // Text controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable state
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Validators
  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 8) {
      return 'Password length should be at least 8 characters';
    }
    return null;
  }

  // Change Password Action
  Future<void> onChangePassword() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await ChangePasswordApi.changePassword(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
        );
        
        Get.snackbar(
          'Success',
          'Password updated successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        currentPasswordController.clear();
        newPasswordController.clear();
        Get.back(); // Go back after success
      } catch (e) {
        debugPrint('Change Password Error: $e');
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
