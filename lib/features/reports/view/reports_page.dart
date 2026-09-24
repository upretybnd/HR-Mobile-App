import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/features/reports/controller/reports_controller.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportsController controller = Get.put(ReportsController());
    return MainLayout(
      showAppBar: true,
      showHeader: true,
      showBackButton: true,
      title: 'HR Management',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostReportDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildSummaryCard(
                    title: 'Total Employees',
                    count: controller.totalEmployeesCount,
                    supportingText: '+12 this month',
                    icon: Icons.people_outline,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'Total Interns',
                    count: controller.totalInternsCount,
                    supportingText: '+5 this month',
                    icon: Icons.school_outlined,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'Attendance Rate',
                    count: controller.attendanceRate,
                    supportingText: 'Consistent',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'Pending Leaves',
                    count: controller.pendingLeavesCount,
                    supportingText: 'Requires action',
                    icon: Icons.event_busy_outlined,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    title: 'Intern End Dates',
                    count: controller.internEndDatesCount,
                    supportingText: 'Approaching soon',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.error,
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),

            // Urgent Notice Section
            const Text(
              'Urgent Notice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildUrgentNoticeCard(),
            const SizedBox(height: 24),

            // Automated Reports Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Automated Reports',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.fetchReports(),
                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                  tooltip: 'Refresh Reports',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.reports.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No reports generated yet.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.reports.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final report = controller.reports[index];
                  final style = _getReportStyle(report.type);
                  final date = DateFormat('MMM d, yyyy - hh:mm a').format(report.createdAt.toLocal());
                  return _buildReportItem(
                    title: style['title'] as String,
                    lastGenerated: 'Generated: $date',
                    frequency: report.format,
                    icon: style['icon'] as IconData,
                    iconColor: style['color'] as Color,
                  );
                },
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getReportStyle(String type) {
    switch (type) {
      case 'ATTENDANCE':
        return {'title': 'Attendance Summary', 'icon': Icons.calendar_today_outlined, 'color': AppColors.primary};
      case 'LEAVE':
        return {'title': 'Leave Analytics', 'icon': Icons.event_busy_outlined, 'color': AppColors.secondary};
      case 'EMPLOYEE_STATS':
        return {'title': 'Employee Stats', 'icon': Icons.people_outline, 'color': AppColors.info};
      case 'INTERN_STATS':
        return {'title': 'Intern Stats', 'icon': Icons.school_outlined, 'color': AppColors.warning};
      case 'PAYROLL':
        return {'title': 'Payroll', 'icon': Icons.attach_money, 'color': AppColors.success};
      default:
        return {'title': 'Report', 'icon': Icons.insert_drive_file_outlined, 'color': AppColors.textSecondary};
    }
  }

  void _showPostReportDialog(BuildContext context) {
    String selectedType = 'ATTENDANCE';
    String selectedFormat = 'PDF';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.note_add, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Post Report',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Report Type',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(value: 'ATTENDANCE', child: Text('Attendance')),
                      DropdownMenuItem(value: 'LEAVE', child: Text('Leave')),
                      DropdownMenuItem(value: 'EMPLOYEE_STATS', child: Text('Employee Stats')),
                      DropdownMenuItem(value: 'INTERN_STATS', child: Text('Intern Stats')),
                      DropdownMenuItem(value: 'PAYROLL', child: Text('Payroll')),
                    ],
                    onChanged: (val) {
                      if (val != null) selectedType = val;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Format',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedFormat,
                    items: const [
                      DropdownMenuItem(value: 'PDF', child: Text('PDF')),
                      DropdownMenuItem(value: 'CSV', child: Text('CSV')),
                      DropdownMenuItem(value: 'EXCEL', child: Text('Excel')),
                    ],
                    onChanged: (val) {
                      if (val != null) selectedFormat = val;
                    },
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          try {
                            await Get.find<ReportsController>().postReport(selectedType, selectedFormat);
                            if (context.mounted) {
                              Navigator.pop(context);
                              Get.snackbar(
                                'Success',
                                'Report posted successfully',
                                backgroundColor: AppColors.success,
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);
                            Get.snackbar(
                              'Error',
                              e.toString().replaceAll('Exception: ', ''),
                              backgroundColor: AppColors.error,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required String supportingText,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            supportingText,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.secondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '06 Intern End Dates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'There are 6 interns whose end dates are approaching in the next 7 days. Please review their performance and take necessary actions.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Review Interns',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem({
    required String title,
    required String lastGenerated,
    required String frequency,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        frequency,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  lastGenerated,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined, color: AppColors.textSecondary),
            tooltip: 'Download Report',
          ),
        ],
      ),
    );
  }
}
const FontWeight bold = FontWeight.w600;
