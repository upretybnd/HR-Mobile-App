import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader; 

  const MainLayout({
    super.key,
    required this.child,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBg,
      child: Column(
        children: [
          if (showHeader) _buildCommonHeader(),
          Expanded(child: child),
        ],
      ),
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
            'HR Management',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 2),
          Text(
            'Sunday, 7 June 2026',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          SizedBox(height: 10),
          Divider(color: AppColors.disabled, height: 1),
        ],
      ),
    );
  }
}