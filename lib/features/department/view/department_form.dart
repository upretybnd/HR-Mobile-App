import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/department/api/department_api.dart';
import 'package:hr_management/features/department/controller/department_controller.dart';

import 'package:hr_management/features/department/model/department_model.dart';

class DepartmentForm extends StatefulWidget {
  final DepartmentModel? departmentToEdit;

  const DepartmentForm({super.key, this.departmentToEdit});

  @override
  State<DepartmentForm> createState() => _DepartmentFormState();
}

class _DepartmentFormState extends State<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  final DepartmentController _controller = Get.find<DepartmentController>();

  @override
  void initState() {
    super.initState();
    if (widget.departmentToEdit != null) {
      _nameController.text = widget.departmentToEdit!.name;
      _descriptionController.text = widget.departmentToEdit!.description;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.departmentToEdit != null) {
        await _controller.updateDepartmentsById(
          widget.departmentToEdit!.id,
          _nameController.text.trim(),
          _descriptionController.text.trim(),
        );
        Get.back(); // Close dialog
        Get.snackbar(
          'Success',
          'Department updated successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final success = await DepartmentApi.postDepartments(
          _nameController.text.trim(),
          _descriptionController.text.trim(),
        );

        if (success) {
          Get.back(); // Close dialog
          Get.snackbar(
            'Success',
            'Department created successfully.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          _controller.fetchDepartments(); // Refresh list
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save department. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.departmentToEdit != null ? 'Edit Department' : 'Create Department',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                const Text(
                  'Department Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Frontend',
                    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a department name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe the department...',
                    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            widget.departmentToEdit != null ? 'Update Department' : 'Create Department',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
