import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader;
  final bool showAppBar;
  final bool showBackButton;
  final String title;

  const MainLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showAppBar = false,
    this.showBackButton = true,
    this.title = 'HR Management',
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      color: AppColors.scaffoldBg,
      child: Column(
        children: [
          if (showHeader) _buildCommonHeader(),
          Expanded(child: child),
        ],
      ),
    );

    if (!showAppBar) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Get.back(),
              )
            : null,
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
      body: SafeArea(child: content),
    );
  }

  Widget _buildCommonHeader() {
    return Container(
      color: AppColors.scaffoldBg,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          const Text(
            'Sunday, 7 June 2026',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.disabled, height: 1),
        ],
      ),
    );
  }
}