import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/authentication/api/create_account_api.dart';

class CreateAccountController extends GetxController{
  // Text Controllers
  final fullnameController =TextEditingController();
  final emailController =TextEditingController();
  final passwordController =TextEditingController();
  final formKey =GlobalKey<FormState>();

  // Observable State
  final obscurePassword =true.obs;
  final isLoading =false.obs;
  final selectedDepartment = Rxn<String>();

  // Department List
  final departments = [
    'Human Resources',
    'Engineering',
    'Marketing',
    'Finance',
    'Operations',
    'Sales',
    'Design',
    'Support',
  ];

  // Dispose
  @override
  void onClose(){
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility(){
    obscurePassword.value=!obscurePassword.value;
  }

  void setDepartment(String? value) {
    selectedDepartment.value = value;
  }

  // validators
  String? validateFullname(String?value){
    if(value ==null || value.isEmpty){
      return 'Please enter your full name';
    }
    return null;
  }
  
  String? validateEmail(String?value){
    if(value ==null || value.isEmpty){
      return 'Please enter your email';
    }
    if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
      return 'Please enter valid email';
    }
    return null;
  }

  String? validatePassword(String?value){
    if(value == null || value.isEmpty){
      return 'Please enter your password';
    }
    return null;
  }

  String? validateDepartment(String? value) {
    if (value == null) {
      return 'Please select a department';
    }
    return null;
  }

// POST Api call for create account 
  Future<void> onCreateAccount() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
         await CreateAccountApi.registerUser(
          name: fullnameController.text,
          email: emailController.text,
          department: selectedDepartment.value ?? '',
          password: passwordController.text,
        );
      } catch (e) {
        debugPrint('Registration Error: $e');
        Get.snackbar(
          'Error', 
          'Network error. Please check your connection.',
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void onLoginTap() {
    Get.back();
  }
}