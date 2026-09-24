import 'package:get/get.dart';
import 'package:hr_management/features/authentication/api/user_api.dart';
import 'package:hr_management/features/authentication/model/user_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final isLoading = true.obs;
  final user = Rxn<UserData>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);
      errorMessage('');
      final userModel = await UserApi.getUser();
      if (userModel.success) {
        user.value = userModel.data;
      } else {
        errorMessage.value = userModel.message;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      debugPrint('Error fetching user profile: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> editUserProfile(String firstName, String lastName, String phone) async {
    try {
      await UserApi.editUser(firstName, lastName, phone);
      await fetchUserProfile();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      throw e;
    }
  }
}
