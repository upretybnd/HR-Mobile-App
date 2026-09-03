import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader; 
  final bool showSearchBar;
  final String searchHintText;

  const MainLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showSearchBar = true,
    this.searchHintText = 'Search here',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
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