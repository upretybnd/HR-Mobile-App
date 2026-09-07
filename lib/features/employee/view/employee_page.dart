import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';

import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';

class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Search Bar
              const SearchBarWidget(hintText: 'Search employee'),
              SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All Employees'),
                    SizedBox(width: 8),
                    _buildFilterChip('All Status'),
                    SizedBox(width: 8),
                    _buildFilterChip('Department'),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // Employee List
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildEmployeeCard(
                    initials: 'MH',
                    name: 'Marcus Holloway',
                    email: 'm.holloway@hrnexus.com',
                    roleDept: 'Senior Engineer · Engineering',
                    status: 'ACTIVE',
                  ),
                  _buildEmployeeCard(
                    initials: 'DM',
                    name: 'David Miller',
                    email: 'd.miller@hrnexus.com',
                    roleDept: 'Product Manager · Product',
                    status: 'PENDING',
                  ),
                  _buildEmployeeCard(
                    initials: 'ER',
                    name: 'Elena Rodriguez',
                    email: 'e.rodriguez@hrnexus.com',
                    roleDept: 'QA Engineer · Engineering',
                    status: 'ACTIVE',
                  ),
                  _buildEmployeeCard(
                    initials: 'JW',
                    name: 'James Wilson',
                    email: 'j.wilson@hrnexus.com',
                    roleDept: 'Backend Developer · Engineering',
                    status: 'INACTIVE',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Pagination Footer
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Showing 1 to 5 of 42 requests',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconPageButton(Icons.chevron_left),
                      SizedBox(width: 4),
                      _buildPageButton('1', isActive: true),
                      SizedBox(width: 4),
                      _buildPageButton('2'),
                      SizedBox(width: 4),
                      _buildPageButton('3'),
                      SizedBox(width: 4),
                      _buildIconPageButton(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard({
    required String initials,
    required String name,
    required String email,
    required String roleDept,
    required String status,
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
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha:0.1),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusPill(status),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'ROLE & DEPT',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textHint,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            roleDept,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        bgColor = AppColors.success.withValues(alpha:0.1);
        textColor = AppColors.success;
        break;
      case 'PENDING':
        bgColor = AppColors.warning.withValues(alpha:0.1);
        textColor = AppColors.warning;
        break;
      case 'INACTIVE':
      default:
        bgColor = AppColors.disabledText.withValues(alpha:0.1);
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPageButton(String text, {bool isActive = false}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? null : Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.textPrimary,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildIconPageButton(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 16,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}