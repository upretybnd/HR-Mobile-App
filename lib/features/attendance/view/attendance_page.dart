import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';
import 'package:hr_management/features/attendance/controller/attendance_controller.dart';
import 'package:hr_management/features/attendance/model/attendance_model.dart';
import 'package:hr_management/features/attendance/view/attendance_form.dart';

class AttendancePage extends StatelessWidget {
  AttendancePage({super.key});

  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showHeader: true,
      child: Container(
        color: AppColors.scaffoldBg, 
        child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Date Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Attendance Log',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Sept 04, 2023',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.calendar_today, size: 12, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Top Statistics Cards
                    Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatCard("TODAY'S PRESENCE", "${controller.presentCount}", "${controller.attendanceRecords.length} total", AppColors.success, true),
                          _buildStatCard("ABSENT", "${controller.absentCount}", "", AppColors.textSecondary, true),
                          _buildStatCard("LATE ARRIVALS", "${controller.lateCount}", "", AppColors.warning, false),
                        ],
                      ),
                    )),
                    const SizedBox(height: 12),

                    // Search Bar
                    const SearchBarWidget(
                      hintText: 'Search Employees',
                      suffixIcon: Icons.tune,
                    ),
                    const SizedBox(height: 16),

                    // Attendance Cards from API
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (controller.attendanceRecords.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'No attendance records found.',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.attendanceRecords.length,
                        itemBuilder: (context, index) {
                          final record = controller.attendanceRecords[index];
                          return _buildAttendanceCard(record);
                        },
                      );
                    }),
                
                const SizedBox(height: 12),

                // Pagination Footer
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.attendanceRecords.length} employees',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    Row(
                      children: [
                        _buildPaginationButton('Prev'),
                        const SizedBox(width: 8),
                        _buildPaginationButton('Next'),
                      ],
                    ),
                  ],
                )),
                const SizedBox(height: 16),

                // Add Attendance Button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.dialog(AttendanceForm(isCheckIn: true)),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, String subtitle, Color subtitleColor, bool hasRightMargin) {
    return Container(
      width: 140, // Fixed width so cards don't shrink
      margin: EdgeInsets.only(right: hasRightMargin ? 12 : 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10, 
              color: AppColors.textSecondary, 
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10, 
              color: subtitleColor, 
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record) {
    final employee = record.employee;
    final user = employee.user;
    final initials = '${user.firstName.isNotEmpty ? user.firstName[0] : ''}${user.lastName.isNotEmpty ? user.lastName[0] : ''}'.toUpperCase();
    final name = user.fullName;
    final position = employee.position;
    final status = record.status;
    final clockIn = controller.formatTime(record.checkIn);
    final clockOut = controller.formatTime(record.checkOut);

    Color avatarColor;
    switch (status.toUpperCase()) {
      case 'PRESENT':
        avatarColor = AppColors.primary;
        break;
      case 'LATE':
        avatarColor = AppColors.warning;
        break;
      case 'ABSENT':
        avatarColor = AppColors.error;
        break;
      default:
        avatarColor = AppColors.primaryDark;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarColor,
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
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      position,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusPill(status),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CLOCK IN',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clockIn,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CLOCK OUT',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clockOut,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.dialog(AttendanceForm(isCheckIn: false)),
                child: const Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PRESENT':
        bgColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'LATE':
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case 'ABSENT':
      default:
        bgColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaginationButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
