import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/department/controller/department_controller.dart';
import 'package:hr_management/features/department/model/department_model.dart';
import 'package:hr_management/features/department/view/department_form.dart';
import 'package:hr_management/features/department/view/department_detail_page.dart';

class DepartmentPage extends StatelessWidget {
  DepartmentPage({super.key});

  final DepartmentController controller = Get.put(DepartmentController());

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showAppBar: true,
      showHeader: true,
      title: 'HR Management',
      floatingActionButton: Obx(() => controller.userRole.value.toUpperCase() == 'ADMIN'
          ? FloatingActionButton(
              heroTag: null,
              backgroundColor: AppColors.primary,
              onPressed: () => Get.dialog(const DepartmentForm(), useSafeArea: true),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : const SizedBox.shrink()),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reusable Search Bar
              SearchBarWidget(
                hintText: 'Search departments...',
                suffixIcon: Icons.tune,
                onChanged: (value) => controller.searchQuery.value = value,
              ),
              const SizedBox(height: 24),
              
              // List of Departments
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final filtered = controller.filteredDepartments;

                if (filtered.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No departments found.', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildDepartmentCard(filtered[index], index);
                  },
                );
              }),
              
              const SizedBox(height: 16),
              
              // Simple Pagination
              _buildPagination(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentCard(DepartmentModel dept, int index) {
    final bool isActive = dept.manager?.status.toUpperCase() == 'ACTIVE' || dept.manager == null; // Fallback logic since status is on manager
    final String name = dept.name;
    final String head = dept.manager?.user.fullName ?? 'No Manager';
    final int members = dept.count.employees;
    
    // Generate distinct colors based on index for the avatar
    final colors = [
      Colors.blue, Colors.orange, Colors.purple, Colors.green, Colors.red, Colors.teal
    ];
    final color = colors[index % colors.length];
    
    return GestureDetector(
      onTap: () => Get.to(() => DepartmentDetailPage(departmentId: dept.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon/Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'D',
              style: TextStyle(
                color: color.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  head,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$members members',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Status Badge and Menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => controller.userRole.value.toUpperCase() == 'ADMIN'
                  ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.dialog(DepartmentForm(departmentToEdit: dept), useSafeArea: true);
                        } else if (value == 'delete') {
                          _showDeleteDialog(dept);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(height: 20)),
              const SizedBox(height: 12),
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
        ],
      ),
    ));
  }

  void _showDeleteDialog(DepartmentModel dept) {
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
              Get.back(); // Close dialog
              final success = await controller.deleteDepartmentsById(dept.id);
              if (success) {
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
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          final count = controller.filteredDepartments.length;
          return Text(
            'Showing 1 to $count of $count entries',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          );
        }),
        Row(
          children: [
            _buildPageButton(Icons.chevron_left, false),
            const SizedBox(width: 4),
            _buildPageNumber('1', true),
            const SizedBox(width: 4),
            _buildPageButton(Icons.chevron_right, false),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(IconData icon, bool isActive) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: AppColors.textSecondary),
    );
  }

  Widget _buildPageNumber(String text, bool isActive) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}
