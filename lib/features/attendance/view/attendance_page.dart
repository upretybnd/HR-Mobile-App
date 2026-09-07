import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatCard("TODAY'S PRESENCE", "140", "4% vs Yesterday", AppColors.success, true),
                          _buildStatCard("ABSENT", "37", "3 on approved leave", AppColors.textSecondary, true),
                          _buildStatCard("LATE ARRIVALS", "08", "2% increase", AppColors.warning, false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Search Bar
                    const SearchBarWidget(
                      hintText: 'Search Employees',
                      suffixIcon: Icons.tune,
                    ),
                    const SizedBox(height: 16),

                    // Compact Employee Attendance Cards
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAttendanceCard(
                      initials: 'MH',
                      name: 'Marcus Holloway',
                      position: 'Senior Engineer',
                      status: 'PRESENT',
                      clockIn: '08:55 AM',
                      clockOut: '--:--',
                      avatarColor: AppColors.primary,
                    ),
                    _buildAttendanceCard(
                      initials: 'DM',
                      name: 'David Miller',
                      position: 'Product Manager',
                      status: 'LATE',
                      clockIn: '09:30 AM',
                      clockOut: '--:--',
                      avatarColor: AppColors.secondary,
                    ),
                    _buildAttendanceCard(
                      initials: 'ER',
                      name: 'Elena Rodriguez',
                      position: 'QA Engineer',
                      status: 'ABSENT',
                      clockIn: '--:--',
                      clockOut: '--:--',
                      avatarColor: AppColors.error,
                    ),
                    _buildAttendanceCard(
                      initials: 'JW',
                      name: 'James Wilson',
                      position: 'Backend Developer',
                      status: 'PRESENT',
                      clockIn: '09:00 AM',
                      clockOut: '06:05 PM',
                      avatarColor: AppColors.primaryDark,
                    ),
                    _buildAttendanceCard(
                      initials: 'SJ',
                      name: 'Sarah Jenkins',
                      position: 'UI/UX Designer',
                      status: 'PRESENT',
                      clockIn: '08:58 AM',
                      clockOut: '--:--',
                      avatarColor: AppColors.primaryLight,
                    ),
                    _buildAttendanceCard(
                      initials: 'TR',
                      name: 'Tom Riddle',
                      position: 'Marketing Lead',
                      status: 'LATE',
                      clockIn: '10:15 AM',
                      clockOut: '--:--',
                      avatarColor: AppColors.warning,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                // Pagination Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '4 of 128 employees',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    Row(
                      children: [
                        _buildPaginationButton('Prev'),
                        const SizedBox(width: 8),
                        _buildPaginationButton('Next'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Add Attendance Button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
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

  Widget _buildAttendanceCard({
    required String initials,
    required String name,
    required String position,
    required String status,
    required String clockIn,
    required String clockOut,
    required Color avatarColor,
  }) {
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
              const Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
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
