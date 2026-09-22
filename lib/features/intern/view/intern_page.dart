import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';
import 'package:hr_management/features/intern/controller/interns_controller.dart';
import 'package:hr_management/features/intern/model/interns_model.dart';
import 'package:hr_management/features/department/controller/department_controller.dart';

class InternPage extends StatelessWidget {
  const InternPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InternsController controller = Get.put(InternsController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Image.asset('assets/images/CompanyLogo.png', height: 40),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 28,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: 10),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'DG',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.scaffoldBg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: MainLayout(
        showHeader: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (controller.userRole.value == 'EMPLOYEE' && controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80.0, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 24),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  const SearchBarWidget(hintText: 'Search Interns...'),
                  const SizedBox(height: 16),
                  _buildFilters(),
                  const SizedBox(height: 24),
                  const Text(
                    'Intern List',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInternList(controller),
                  const SizedBox(height: 16),
                  _buildPagination(),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          'Total Interns',
          '15',
          subValue: '+4 this month',
          color: AppColors.disabled,
        ),
        _buildStatCard('Active Interns', '13', color: AppColors.disabled),
        _buildStatCard(
          'Interns On Leave',
          '2',
          subValue: 'Medical',
          color: AppColors.disabled,
        ),
        _buildStatCard(
          'Internship completed',
          '50+',
          color: AppColors.disabled,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value, {
    String? subValue,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subValue != null) ...[
                const SizedBox(width: 4),
                Text(
                  subValue,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildFilterChip('All Interns', isSelected: true),
        const SizedBox(width: 8),
        _buildFilterChip('Status', hasDropdown: true),
        const SizedBox(width: 8),
        _buildFilterChip('Department', hasDropdown: true),
      ],
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isSelected = false,
    bool hasDropdown = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInternList(InternsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      if (controller.internsList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No interns found.'),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.internsList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final intern = controller.internsList[index];
          return _buildInternCard(context, intern, controller);
        },
      );
    });
  }

  Widget _buildInternCard(
    BuildContext context,
    Intern intern,
    InternsController controller,
  ) {
    final String initials =
        '${intern.firstName.isNotEmpty ? intern.firstName[0].toUpperCase() : ''}${intern.lastName.isNotEmpty ? intern.lastName[0].toUpperCase() : ''}';
    final Color statusColor = intern.isActive
        ? AppColors.primary
        : AppColors.secondary;
    final String statusText = intern.isActive ? 'ACTIVE' : 'INACTIVE';
    final String dateStr = intern.createdAt != null
        ? '${intern.createdAt!.year}-${intern.createdAt!.month.toString().padLeft(2, '0')}-${intern.createdAt!.day.toString().padLeft(2, '0')}'
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar, Name, Email, Menu
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intern.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      intern.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (intern.isActive)
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                  ),
                  onSelected: (value) {
                    if (value == 'convert') {
                      _showConvertDialog(context, intern, controller);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'convert',
                      child: Text('Convert to Employee'),
                    ),
                  ],
                )
              else
                const Icon(Icons.more_vert, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 16),

          // Middle Row: Role/Dept and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.work_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    intern.role,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bottom Row: Status and View Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.chevron_left, color: AppColors.disabledText),
        ),
        const Text(
          'Page 1 of 5',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_right, color: AppColors.primary),
        ),
      ],
    );
  }

  void _showConvertDialog(
    BuildContext context,
    Intern intern,
    InternsController controller,
  ) {
    final departmentController = Get.put(DepartmentController());
    String? selectedDeptId;
    String position = '';
    String employeeType = 'FULL_TIME'; // default

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Convert ${intern.fullName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Obx(() {
            if (departmentController.isLoading.value &&
                departmentController.departments.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: selectedDeptId,
                    items: departmentController.departments.map((dept) {
                      return DropdownMenuItem(
                        value: dept.id,
                        child: Text(dept.name),
                      );
                    }).toList(),
                    onChanged: (val) => selectedDeptId = val,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Position',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => position = val,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Employee Type',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: employeeType,
                    items: const [
                      DropdownMenuItem(
                        value: 'FULL_TIME',
                        child: Text('Full Time'),
                      ),
                      DropdownMenuItem(
                        value: 'PART_TIME',
                        child: Text('Part Time'),
                      ),
                      DropdownMenuItem(
                        value: 'CONTRACT',
                        child: Text('Contract'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) employeeType = val;
                    },
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDeptId != null && position.trim().isNotEmpty) {
                  Get.back();
                  controller.convertIntern(
                    intern.id,
                    selectedDeptId!,
                    position.trim(),
                    employeeType,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please fill all fields',
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    colorText: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Convert',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
