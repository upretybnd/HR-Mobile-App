import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/features/intern/view/intern_page.dart';
import 'package:hr_management/features/leave/view/leave_page.dart';
import 'package:hr_management/features/announcement/view/announcement_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showHeader: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore More',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMoreItem(
                    Icons.school, 
                    'Interns',
                    onTap: () {
                      Get.to(
                        () => const InternPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                  _buildMoreItem(Icons.corporate_fare, 'Departments'),
                  _buildMoreItem(
                    Icons.event_busy, 
                    'Leaves',
                    onTap: () {
                      Get.to(
                        () => const LeavePage(),
                        transition: Transition.noTransition,
                      );
                    },),
                    
                  _buildMoreItem(
                    Icons.campaign, 
                    'Announce',
                    onTap: () {
                      Get.to(
                        () => const AnnouncementPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                  _buildMoreItem(Icons.chat, 'Chat'),
                  _buildMoreItem(Icons.description, 'Documents'),
                  _buildMoreItem(Icons.attach_money, 'Salary'),
                  _buildMoreItem(Icons.bar_chart, 'Reports'),
                  _buildMoreItem(Icons.settings, 'Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreItem(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.disabledText.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}