import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/authentication/api/forgot_password.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> onSendResetLink() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await ForgotPassword.postForgotPassword(email: emailController.text.trim());
        Get.snackbar(
          'Success',
          'A password reset link has been sent to your email.',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 4),
        );
        // Optional: navigate back to login automatically after success
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } catch (e) {
        debugPrint('Forgot Password Error: $e');
        Get.snackbar(
          'Error',
          'Failed to send reset link. Please try again.',
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
