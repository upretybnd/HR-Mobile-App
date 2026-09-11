import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';

import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/features/leave/controller/leave_form_controller.dart';
import 'package:hr_management/features/leave/model/leave_type_model.dart';

class LeaveForm extends StatelessWidget {
  LeaveForm({super.key});

  final LeaveFormController controller = Get.put(LeaveFormController());

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showAppBar: true,
      showHeader: true,
      child: Center(
        child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildFormBody(context),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Apply for Leave',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please fill in the details for your time-off request.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormBody(BuildContext context) {
    const peachBorderColor = Color(0xFFE8D5C4);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Leave Type'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: peachBorderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                return DropdownButton<LeaveTypeModel>(
                  value: controller.selectedLeaveType.value,
                  hint: const Text('Select Leave Type', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  items: controller.leaveTypes.map((type) {
                    return DropdownMenuItem<LeaveTypeModel>(
                      value: type,
                      child: Text('${type.name}', style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: controller.setSelectedLeaveType,
                );
              }),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Start Date'),
                    const SizedBox(height: 8),
                    _buildDateField(context, peachBorderColor, true),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('End Date'),
                    const SizedBox(height: 8),
                    _buildDateField(context, peachBorderColor, false),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildLabel('Reason / Description'),
          const SizedBox(height: 8),
          TextField(
            controller: controller.reasonController,
            maxLines: 4,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Briefly explain the reason for your leave...',
              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: peachBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: peachBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildLabel('Attachments (Optional)'),
          const SizedBox(height: 8),
          
          CustomPaint(
            painter: DashedRectPainter(color: peachBorderColor, radius: 8, strokeWidth: 1.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F8FB),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: AppColors.textSecondary, size: 36),
                    const SizedBox(height: 12),
                    const Text(
                      'Upload Medical Certificate or documents',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF, JPG, PNG UP TO 5MB',
                      style: TextStyle(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          
          Row(
            children: [
              TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value ? null : controller.submitLeaveRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.send_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Submit Application', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDateField(BuildContext context, Color borderColor, bool isStart) {
    return GestureDetector(
      onTap: () => isStart ? controller.pickStartDate(context) : controller.pickEndDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(() {
          final date = isStart ? controller.startDate.value : controller.endDate.value;
          return Text(
            date != null 
                ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}" 
                : 'mm/dd/yyyy',
            style: TextStyle(
              color: date != null ? AppColors.textPrimary : AppColors.textHint, 
              fontSize: 14,
            ),
          );
        }),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashWidth;
  final double radius;

  DashedRectPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashWidth = 5.0,
    this.radius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
