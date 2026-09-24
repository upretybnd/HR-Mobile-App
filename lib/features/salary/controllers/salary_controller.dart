import 'package:get/get.dart';
import 'package:hr_management/features/employee/controller/employee_controller.dart';
import 'package:hr_management/features/salary/api/salary_api.dart';
import 'package:hr_management/features/salary/model/salary_model.dart';
import 'package:hr_management/features/salary/model/payslip_model.dart';
import 'package:flutter/material.dart';

class SalaryController extends GetxController {
  final isLoading = false.obs;
  final salaries = <String, SalaryData>{}.obs; // employeeId -> SalaryData
  final payslips = <String, PayslipData>{}.obs; // employeeId -> latest PayslipData
  final employeeController = Get.put(EmployeeController());

  @override
  void onInit() {
    super.onInit();
    // Wait for employees to load, then fetch salaries
    ever(employeeController.employees, (_) {
      if (employeeController.employees.isNotEmpty) {
        fetchAllSalaries();
        fetchAllPayslips();
      }
    });
    
    if (employeeController.employees.isNotEmpty) {
      fetchAllSalaries();
      fetchAllPayslips();
    }
  }

  Future<void> fetchAllSalaries() async {
    isLoading.value = true;
    try {
      final newSalaries = <String, SalaryData>{};
      for (var emp in employeeController.employees) {
        try {
          final res = await SalaryApi.getSalaryStructure(emp.id);
          if (res.success) {
            newSalaries[emp.id] = res.data;
          }
        } catch (e) {
          // If an employee doesn't have a salary structure, it will throw. We just skip them.
          debugPrint('No salary structure for ${emp.id}: $e');
        }
      }
      salaries.assignAll(newSalaries);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllPayslips() async {
    try {
      final list = await SalaryApi.fetchPayslip();
      final newPayslips = <String, PayslipData>{};
      for (var slip in list) {
        // We can just keep the latest payslip per employee
        newPayslips[slip.employeeId] = slip;
      }
      payslips.assignAll(newPayslips);
    } catch (e) {
      debugPrint('Failed to fetch payslips: $e');
    }
  }
  
  Future<void> updatePayslipStatus(String id, String status) async {
    try {
      await SalaryApi.patchPayslip(id, status);
      await fetchAllPayslips(); // Refresh payslips after update
      Get.snackbar('Success', 'Payslip status updated to $status');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }
  
  Future<void> refreshSalaries() async {
    await employeeController.fetchEmployees();
    await fetchAllSalaries();
    await fetchAllPayslips();
  }

  Future<void> createSalaryStructure(String employeeId, num baseSalary, num allowances, num deductions) async {
    try {
      await SalaryApi.postSalaryStructure(employeeId, baseSalary, allowances, deductions);
      await fetchAllSalaries();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> generatePayroll(int month, int year) async {
    try {
      await SalaryApi.generatePayroll(month, year);
      await fetchAllPayslips();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
