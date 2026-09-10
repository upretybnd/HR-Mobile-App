import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/controllers/navigation_controller.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/attendance/view/attendance_page.dart';
import 'package:hr_management/features/dashboard/view/dashboard_main.dart';
import 'package:hr_management/features/employee/view/employee_page.dart';
import 'package:hr_management/features/more/view/more_page.dart';

class MainNavigation extends StatelessWidget {
  MainNavigation({super.key});

  final NavigationController navController = Get.put(NavigationController());

  final List<Widget> pages = [
    DashboardMain(),
    EmployeePage(),
    AttendancePage(),
    MorePage(),
  ];

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
      body: Obx(() => IndexedStack(
        index: navController.currentIndex.value,
        children: pages,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.disabledText,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: navController.currentIndex.value,
        onTap: navController.changePage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Employees'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), label: 'More'),
        ],
      )),
    );
  }
}
