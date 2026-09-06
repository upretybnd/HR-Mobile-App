import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.notifications_outlined, size: 28, color: AppColors.textPrimary),
                const SizedBox(width: 10),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
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
      // We rely on MainLayout for the header
      body: SafeArea(
        child: MainLayout(
          showHeader: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Horizontal Summary Section
                  Row(
                    children: [
                      _buildSummaryCard("Pending", "12", '+2 on pending', AppColors.warning),
                      const SizedBox(width: 16),
                      _buildSummaryCard("Approved Today", "8", '+4 are on leave', AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Search Field (Scrollable)
                  const SearchBarWidget(
                    hintText: 'Search employees...',
                    suffixIcon: Icons.tune,
                  ),
                  const SizedBox(height: 24),

                  // 3. "Leave Requests" Heading
                  const Text(
                    'Leave Requests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Leave Request Cards
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildLeaveCard(
                        initials: 'AM',
                        name: 'Alice Morgan',
                        timeAgo: 'Applied 2h ago',
                        leaveType: 'VACATION',
                        status: 'PENDING',
                        dates: 'Oct 12 - Oct 15',
                        days: '4 days',
                        reason: 'Family trip out of town.',
                        avatarColor: AppColors.primary,
                      ),
                      _buildLeaveCard(
                        initials: 'JD',
                        name: 'John Doe',
                        timeAgo: 'Applied 5h ago',
                        leaveType: 'SICK LEAVE',
                        status: 'APPROVED',
                        dates: 'Sept 04',
                        days: '1 day',
                        reason: 'Doctor appointment.',
                        avatarColor: AppColors.secondary,
                      ),
                      _buildLeaveCard(
                        initials: 'SK',
                        name: 'Sarah Khan',
                        timeAgo: 'Applied 1d ago',
                        leaveType: 'PERSONAL',
                        status: 'REJECTED',
                        dates: 'Sept 10 - Sept 11',
                        days: '2 days',
                        avatarColor: AppColors.warning,
                      ),
                    ],
                  ),

                  // Add Leave Request Button
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, String text, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10,),
            Text(text, style: TextStyle(
              fontSize: 12, color: accentColor
            ),)
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveCard({
    required String initials,
    required String name,
    required String timeAgo,
    required String leaveType,
    required String status,
    required String dates,
    required String days,
    String? reason,
    required Color avatarColor,
  }) {
    bool isPending = status == 'PENDING';
    Color statusColor;
    if (status == 'APPROVED') statusColor = AppColors.success;
    else if (status == 'REJECTED') statusColor = AppColors.error;
    else statusColor = AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Time, Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: avatarColor.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          
          // Badges
          Row(
            children: [
              _buildBadge(leaveType, AppColors.info),
              const SizedBox(width: 8),
              _buildBadge(status, statusColor),
            ],
          ),
          const SizedBox(height: 12),

          // Calendar & Days
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                dates,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  days,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          
          // Reason Box
          if (reason != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                reason,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ),
          ],
          
          if (isPending || status == 'APPROVED') ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            
            // Actions
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Decline', style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Approve', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ),
                ],
              )
            else if (status == 'APPROVED')
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: const [
                        Text('View Details', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
