import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/features/recruitment/model/recruitment_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hr_management/features/recruitment/controller/recruitment_controller.dart';

class JobDetailsPage extends StatelessWidget {
  final JobData job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    String displayStatus = job.status.isNotEmpty
        ? job.status[0].toUpperCase() + job.status.substring(1).toLowerCase()
        : 'Active';
    Color badgeColor = (displayStatus == 'Active' || displayStatus == 'Open')
        ? Colors.green
        : (displayStatus == 'Closed' ? Colors.red : Colors.orange);

    String jobTypeLabel = job.type.isNotEmpty
        ? job.type.replaceAll('_', ' ').split(' ').map((w) =>
            w.isNotEmpty ? w[0].toUpperCase() + w.substring(1).toLowerCase() : '')
            .join(' ')
        : 'Full Time';

    String initials = job.title.isNotEmpty ? job.title[0].toUpperCase() : 'J';

    return MainLayout(
      showAppBar: true,
      showBackButton: true,
      showHeader: true,
      title: 'Job Details',
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Card ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              job.department?.name ?? 'Unknown Department',
                              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                displayStatus,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Job Overview ──
                const Text(
                  'Job Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.business_outlined, 'Department', job.department?.name ?? 'N/A'),
                      const Divider(color: AppColors.border, height: 32),
                      _buildDetailRow(Icons.location_on_outlined, 'Location', job.location.isNotEmpty ? job.location : 'N/A'),
                      const Divider(color: AppColors.border, height: 32),
                      _buildDetailRow(Icons.schedule_outlined, 'Employment Type', jobTypeLabel),
                      const Divider(color: AppColors.border, height: 32),
                      _buildDetailRow(Icons.calendar_today_outlined, 'Posted On', DateFormat('MMM dd, yyyy').format(job.createdAt)),
                      if (job.deadline != null) ...[
                        const Divider(color: AppColors.border, height: 32),
                        _buildDetailRow(Icons.event_outlined, 'Deadline', DateFormat('MMM dd, yyyy').format(job.deadline!)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Description Section ──
                const Text(
                  'Job Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    job.description.isNotEmpty ? job.description : 'No description provided.',
                    style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.6),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Key Information Card ──
                const Text(
                  'Key Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInfoChip(Icons.work_history_outlined, 'Status', displayStatus, badgeColor)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInfoChip(Icons.access_time_filled, 'Type', jobTypeLabel, AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInfoChip(Icons.location_city, 'Location', job.location.isNotEmpty ? job.location : 'N/A', Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInfoChip(
                      Icons.calendar_month,
                      'Posted',
                      DateFormat('MMM dd').format(job.createdAt),
                      Colors.orange,
                    )),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // ── Apply Now Button pinned to bottom ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: ElevatedButton(
                onPressed: job.status.toUpperCase() == 'CLOSED' ? null : () {
                  _showApplyDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: job.status.toUpperCase() == 'CLOSED' ? Colors.grey[300] : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  job.status.toUpperCase() == 'CLOSED' ? 'Applications Closed' : 'Apply Now',
                  style: TextStyle(color: job.status.toUpperCase() == 'CLOSED' ? Colors.grey : Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Detail Row (matches employee detail page style) ──
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : 'N/A',
                style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Info Chip Card ──
  Widget _buildInfoChip(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Apply Dialog (kept intact) ──
  void _showApplyDialog(BuildContext context) {
    final controller = Get.find<RecruitmentController>();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final coverLetterController = TextEditingController();
    
    File? resumeFile;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Apply for Job', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('First Name', firstNameController),
                    const SizedBox(height: 12),
                    _buildTextField('Last Name', lastNameController),
                    const SizedBox(height: 12),
                    _buildTextField('Email', emailController, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _buildTextField('Phone Number', phoneController, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    TextField(
                      controller: coverLetterController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Cover Letter',
                        hintText: 'Write your cover letter here...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          var result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
                          if (result.isNotEmpty) {
                            setState(() {
                              resumeFile = File(result.single.path!);
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: resumeFile != null ? Colors.green : AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(resumeFile != null ? Icons.check_circle : Icons.upload_file, size: 18, color: resumeFile != null ? Colors.green : AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                resumeFile != null ? resumeFile!.path.split('/').last.split('\\').last : 'Upload Resume (PDF, DOC)',
                                style: TextStyle(color: resumeFile != null ? Colors.green : AppColors.primary, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty) {
                            Get.snackbar('Error', 'Please fill First Name, Last Name, and Email');
                            return;
                          }
                          bool success = await controller.applyJob(
                            id: job.id,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            phone: phoneController.text.isNotEmpty ? phoneController.text : null,
                            coverLetter: coverLetterController.text.isNotEmpty ? coverLetterController.text : null,
                            resume: resumeFile,
                          );
                          if (success) {
                            Get.back();
                            Get.snackbar('Success', 'Application submitted successfully!');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Submit Application', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
