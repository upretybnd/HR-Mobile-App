import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/department/api/department_api.dart';
import 'package:hr_management/features/department/model/department_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentController extends GetxController {
  final isLoading = false.obs;
  final departments = <DepartmentModel>[].obs;
  final selectedDepartment = Rxn<DepartmentModel>();
  final searchQuery = ''.obs;
  final userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }
  
  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString('user_role') ?? '';
    fetchDepartments();
  }

// api call to get department
  Future<void> fetchDepartments() async {
    try {
      isLoading.value = true;
      final response = await DepartmentApi.fetchDepartments();
      if (response.success) {
        departments.value = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching departments: $e');
      Get.snackbar(
        'Error',
        'Could not load departments.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // api call to get department by id
  Future<void> fetchDepartmentsById(String id) async {
    try {
      isLoading.value = true;
      final department = await DepartmentApi.fetchDepartmentsById(id);
      selectedDepartment.value = department;
    } catch (e) {
      debugPrint('Error fetching departments: $e');
      Get.snackbar(
        'Error',
        'Could not load departments.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // api call to update department by id
  Future<void> updateDepartmentsById(String id, String name, String description) async {
    try {
      isLoading.value = true;
      final department = await DepartmentApi.updateDepartmentsById(id, name, description);
      selectedDepartment.value = department;
      
      // refresh main list so it shows updated name
      await fetchDepartments();
    } catch (e) {
      debugPrint('Error updating department: $e');
      Get.snackbar(
        'Error',
        'Could not update department.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // api call to delete department by id
  Future<bool> deleteDepartmentsById(String id) async {
    try {
      isLoading.value = true;
      final success = await DepartmentApi.deleteDepartmentsById(id);
      if (success) {
        // refresh main list and clear selected
        selectedDepartment.value = null;
        await fetchDepartments();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting department: $e');
      Get.snackbar(
        'Error',
        'Could not delete department.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  List<DepartmentModel> get filteredDepartments {
    if (searchQuery.value.isEmpty) {
      return departments;
    }
    return departments.where((dept) =>
        dept.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }
}
