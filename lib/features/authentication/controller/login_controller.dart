import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/authentication/api/login_api.dart';

class LoginController extends GetxController {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable State
  final obscurePassword = true.obs;
  final keepMeLoggedIn = false.obs;
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

  // Toggle Keep Me Logged In
  void toggleKeepMeLoggedIn(bool? value) {
    keepMeLoggedIn.value = value ?? false;
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
  Future<void> onLogin() async{
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try{
        await LoginApi.userLogin(
          email: emailController.text,password: passwordController.text);
      }
      catch(e){
        debugPrint('Registration Error : $e');
        Get.snackbar('Error', 
        'Network error. please check your connection.');
      }
    }
  }
}