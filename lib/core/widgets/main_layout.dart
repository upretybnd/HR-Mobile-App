import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/dashboard/view/dashboard_main.dart';
import 'package:hr_management/features/employee/view/employee_page.dart';
import 'package:hr_management/features/more/view/more_page.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader; 
  final bool showSearchBar;
  final int currentIndex;
  final Function(int)? onTabSelected;
  final String searchHintText;

  const MainLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showSearchBar = true,
    this.currentIndex = 0,
    this.onTabSelected,
    this.searchHintText = 'Search here',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Image.asset('assets/images/CompanyLogo.png', height: 40),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              children: [
                Icon(Icons.notifications_outlined, size: 28, color: AppColors.textPrimary),
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
                    'db',
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

      // Bottom Navbar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.disabledText,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          if (onTabSelected != null) {
            onTabSelected!(index);
          } else {
            if (index == currentIndex) return;
            
            Widget? nextPage;
            if (index == 0) nextPage = const DashboardMain();
            if (index == 1) nextPage = const EmployeePage();
            if (index == 3) nextPage = const MorePage();

            if (nextPage != null) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => nextPage!,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Employees'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), label: 'More'),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            if (showHeader) _buildCommonHeader(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonHeader() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HR Management',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 2),
          Text(
            'Sunday, 7 June 2026',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          if (showSearchBar) ...[
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColors.disabledText),
                hintText: searchHintText,
                hintStyle: TextStyle(color: AppColors.disabledText),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ],
          SizedBox(height: 10),
          Divider(color: AppColors.disabled, height: 1),
        ],
      ),
    );
  }
}