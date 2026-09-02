import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  // Text controllers
final currentPasswordController =TextEditingController();
final NewPasswordController =TextEditingController();
final formKey =GlobalKey<FormState>();

// Observable state
final obscurePassword =true.obs;
final isLoading =false.obs;

@override
  void onClose(){
    currentPasswordController.dispose();
    NewPasswordController.dispose();
    super.onClose();
  }

// Toggle password visibility
  void togglePasswordVisibility(){
    obscurePassword.value=!obscurePassword.value;
  }

// validate
String? validatePassword(String?value){
if(value==null || value.isEmpty){
  return 'Please enter valid password';
}
if(currentPasswordController.text.length < 6){
  return 'Password length should be of minimum 8 charcters';
}
return null;
}
}