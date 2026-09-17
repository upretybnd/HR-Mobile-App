import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/features/department/controller/department_controller.dart';
import 'package:hr_management/features/department/view/department_form.dart';

class DepartmentDetailPage extends StatefulWidget {
  final String departmentId;

  const DepartmentDetailPage({super.key, required this.departmentId});

  @override
  State<DepartmentDetailPage> createState() => _DepartmentDetailPageState();
}

class _DepartmentDetailPageState extends State<DepartmentDetailPage> {
  final DepartmentController controller = Get.find<DepartmentController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDepartmentsById(widget.departmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showAppBar: true,
      showHeader: false,
      title: 'HR Management',
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final dept = controller.selectedDepartment.value;

        if (dept == null) {
          return const Center(
            child: Text('Department not found.', style: TextStyle(color: AppColors.textSecondary)),
          );
        }

        final bool isActive = dept.manager?.status.toUpperCase() == 'ACTIVE' || dept.manager == null;
        final String head = dept.manager?.user.fullName ?? 'No Manager Assigned';

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          dept.name.isNotEmpty ? dept.name.substring(0, 1).toUpperCase() : 'D',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dept.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'In Active',
                                style: TextStyle(
                                  color: isActive ? AppColors.success : AppColors.error,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Details Card
                const Text(
                  'About Department',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.description_outlined, 'Description', dept.description.isNotEmpty ? dept.description : 'No description provided.'),
                      const Divider(color: AppColors.border, height: 32),
                      _buildDetailRow(Icons.person_outline, 'Department Head', head),
                      const Divider(color: AppColors.border, height: 32),
                      _buildDetailRow(Icons.people_outline, 'Total Members', '${dept.count.employees} Employees'),
                      const Divider(color: AppColors.border, height: 32),
                      _buildDetailRow(Icons.calendar_today_outlined, 'Created Date', '${dept.createdAt.year}-${dept.createdAt.month.toString().padLeft(2, '0')}-${dept.createdAt.day.toString().padLeft(2, '0')}'),
                    ],
                  ),
                ),
                
                // Admin Actions
                Obx(() {
                  if (controller.userRole.value.toUpperCase() == 'ADMIN') {
                    return Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.dialog(DepartmentForm(departmentToEdit: dept), useSafeArea: true),
                              icon: const Icon(Icons.edit, size: 20),
                              label: const Text('Edit'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Delete Department'),
                                    content: Text('Are you sure you want to delete ${dept.name}? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Get.back(); // close dialog
                                          final success = await controller.deleteDepartmentsById(dept.id);
                                          if (success) {
                                            Get.back(); // go back to list
                                            Get.snackbar(
                                              'Success',
                                              'Department deleted successfully',
                                              backgroundColor: AppColors.success,
                                              colorText: Colors.white,
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                        child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete_outline, size: 20),
                              label: const Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
