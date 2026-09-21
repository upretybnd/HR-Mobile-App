import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/main_navigation.dart';
import 'package:hr_management/features/authentication/api/login_api.dart';
import 'package:hr_management/features/authentication/view/verify_email_page.dart';

class LoginController extends GetxController {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable State
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  // Dispose
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // POST API call for login
  Future<void> onLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await LoginApi.userLogin(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        Get.snackbar(
          'Success',
          'Logged in successfully!',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
        Get.offAll(() => MainNavigation());
      } catch (e) {
        debugPrint('Login Error : $e');
        
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('verify') || errorString.contains('verified')) {
          Get.snackbar(
            'Verification Required',
            'Please verify your email address to login.',
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            colorText: Colors.orange,
            duration: const Duration(seconds: 4),
          );
          Get.to(() => VerifyEmailPage(), arguments: emailController.text.trim());
        } else {
          Get.snackbar(
            'Error',
            e.toString().replaceAll('Exception: ', ''),
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }
}