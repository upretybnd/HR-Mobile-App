import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/authentication/api/verify_email_api.dart';
import 'package:hr_management/features/authentication/api/resend_verification_api.dart';
import 'package:hr_management/features/authentication/view/login_page.dart';

class VerifyEmailController extends GetxController {
  final tokenController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isResending = false.obs;

  String get userEmail => Get.arguments as String? ?? '';

  @override
  void onClose() {
    tokenController.dispose();
    super.onClose();
  }

  String? validateToken(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the verification code';
    }
    return null;
  }

  Future<void> onResendCode() async {
    if (userEmail.isEmpty) {
      Get.snackbar('Error', 'Email address not found. Please register or login again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1), colorText: Colors.red);
      return;
    }
    
    isResending.value = true;
    try {
      await ResendVerificationApi.postResendVerification(email: userEmail);
      Get.snackbar(
        'Code Sent',
        'A new verification code has been sent to your email.',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      debugPrint('Resend Error: $e');
      Get.snackbar(
        'Error',
        'Failed to resend verification code. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isResending.value = false;
    }
  }

  Future<void> onVerify() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await VerifyEmailApi.postVerifyEmail(token: tokenController.text.trim());
        Get.snackbar(
          'Success',
          'Email verified successfully! You can now login.',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
        );
        Get.offAll(() => LoginPage());
      } catch (e) {
        debugPrint('Verification Error: $e');
        Get.snackbar(
          'Error',
          'Invalid verification token or network error.',
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
