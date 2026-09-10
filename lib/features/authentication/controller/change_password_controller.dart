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
        await Future.delayed(const Duration(milliseconds: 800));
        Get.snackbar(
          'Success',
          'Password updated successfully.',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        currentPasswordController.clear();
        newPasswordController.clear();
      } catch (e) {
        debugPrint('Change Password Error: $e');
        Get.snackbar(
          'Error',
          'Failed to update password. Please try again.',
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}