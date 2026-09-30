import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';
import 'package:hr_management/features/recruitment/controller/recruitment_controller.dart';
import 'package:intl/intl.dart';
import 'package:hr_management/features/recruitment/model/recruitment_model.dart';
import 'package:hr_management/features/recruitment/view/job_details_page.dart';

class RecruitmentPage extends StatelessWidget {
  const RecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruitmentController());

    return MainLayout(
      showAppBar: true,
      showBackButton: true,
      showHeader: true,
      title: 'HR Management',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostJobBottomSheet(context, controller),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SearchBarWidget(
              controller: TextEditingController(),
              hintText: 'Search Recruitment...',
              onChanged: (val) => controller.searchQuery.value = val,
            ),
            const SizedBox(height: 16),

            // Top Summary Cards
            Obx(() {
              int totalApps = controller.applications.length;
              int interviewCount = controller.applications.where((app) => app.status.toUpperCase() == 'INTERVIEW').length;
              double interviewRate = totalApps > 0 ? (interviewCount / totalApps) * 100 : 0;
              int openPositions = controller.recruitments.where((job) => job.status.toUpperCase() == 'OPEN' || job.status.toUpperCase() == 'ACTIVE').length;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSummaryCard('Total Applicants', totalApps.toString(), 'All time', true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSummaryCard('Interview Rate', '${interviewRate.toStringAsFixed(0)}%', 'Current', true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard('Open Positions', openPositions.toString(), 'Active jobs', false, fullWidth: true),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Active Openings Section
            const Text(
              'Active Openings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)));
              }
              if (controller.filteredRecruitments.isEmpty) {
                return const Center(child: Text("No active openings found."));
              }
              return Column(
                children: controller.filteredRecruitments.map((job) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildActiveOpeningCard(job, context, controller),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),

            // Applicant Tracking Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Applicant Tracking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Icon(Icons.filter_list, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),

            Obx(() {
              if (controller.applications.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text("No applicants found.")),
                );
              }
              return Column(
                children: controller.applications.map((app) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _buildApplicantCard(
                      app.id,
                      "${app.firstName} ${app.lastName}".trim(),
                      app.email,
                      DateFormat('MMM dd, yyyy').format(app.createdAt),
                      app.job?.department?.name ?? 'Unknown Field',
                      app.status.isNotEmpty ? app.status[0].toUpperCase() + app.status.substring(1).toLowerCase() : 'Pending',
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),

            // Application Sources
            const Text(
              'Application Sources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildSourceProgress('LinkedIn', 45, AppColors.primary),
                  const SizedBox(height: 12),
                  _buildSourceProgress('Company Portal', 30, Colors.blue),
                  const SizedBox(height: 12),
                  _buildSourceProgress('Indeed', 15, Colors.orange),
                  const SizedBox(height: 12),
                  _buildSourceProgress('Employee Referrals', 10, Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Activity
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildActivityTimeline('Michael Chen', 'moved to Offer stage', '2 hours ago', Icons.check_circle, Colors.green),
                  _buildActivityTimeline('Alex Rivers', 'interview scheduled', '4 hours ago', Icons.calendar_month, Colors.blue),
                  _buildActivityTimeline('New application', 'received for Marketing Manager', '5 hours ago', Icons.person_add, AppColors.primary),
                  _buildActivityTimeline('Emma Watson', 'application rejected', '1 day ago', Icons.cancel, Colors.red, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showPostJobBottomSheet(BuildContext context, RecruitmentController controller) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final minSalaryController = TextEditingController();
    final maxSalaryController = TextEditingController();
    
    String? selectedDepartmentId;
    String? selectedType = 'FULL_TIME';

    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: Get.height * 0.85,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Post New Job',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTextField('Job Title', titleController),
                      const SizedBox(height: 12),
                      _buildTextField('Description', descriptionController, maxLines: 3),
                      const SizedBox(height: 12),
                      
                      // Department Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedDepartmentId,
                        hint: const Text('Select Department'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: controller.departments.map((dept) {
                          return DropdownMenuItem(
                            value: dept.id,
                            child: Text(dept.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedDepartmentId = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      _buildTextField('Location', locationController),
                      const SizedBox(height: 12),
                      
                      // Type Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          labelText: 'Job Type',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'FULL_TIME', child: Text('Full-Time')),
                          DropdownMenuItem(value: 'PART_TIME', child: Text('Part-Time')),
                          DropdownMenuItem(value: 'CONTRACT', child: Text('Contract')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedType = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Min Salary', minSalaryController)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField('Max Salary', maxSalaryController)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.isEmpty || selectedDepartmentId == null) {
                            Get.snackbar('Error', 'Please fill required fields (Title and Department)');
                            return;
                          }
                          
                          // Find department name based on ID
                          final deptName = controller.departments.firstWhere((d) => d.id == selectedDepartmentId).name;
                          
                          bool success = await controller.postJob(
                            departmentId: selectedDepartmentId!,
                            title: titleController.text,
                            description: descriptionController.text,
                            department: deptName,
                            location: locationController.text,
                            type: selectedType ?? 'FULL_TIME',
                            salaryMin: minSalaryController.text,
                            salaryMax: maxSalaryController.text,
                          );
                          if (success) {
                            Get.back();
                            Get.snackbar('Success', 'Job posted successfully');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Post Job', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle, bool isPositive, {bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isPositive) const Icon(Icons.arrow_upward, size: 14, color: Colors.green),
              if (isPositive) const SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

    Widget _buildActiveOpeningCard(JobData job, BuildContext context, RecruitmentController controller) {
    String role = job.title;
    String dept = job.department?.name ?? 'Unknown Dept';
    String applicants = '0';
    String status = job.status.isNotEmpty ? job.status : 'Active';
    String displayStatus = status.isNotEmpty ? status[0].toUpperCase() + status.substring(1).toLowerCase() : 'Active';
    Color badgeColor = (displayStatus == 'Active' || displayStatus == 'Open') ? Colors.green : (displayStatus == 'Closed' ? Colors.red : Colors.orange);
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(role, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      displayStatus,
                      style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showUpdateJobBottomSheet(context, controller, job),
                    child: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(dept, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('$applicants Applicants', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
              TextButton(
                onPressed: () => Get.to(() => JobDetailsPage(job: job)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View Details', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUpdateJobBottomSheet(BuildContext context, RecruitmentController controller, JobData job) {
    final titleController = TextEditingController(text: job.title);
    final descriptionController = TextEditingController(text: job.description);
    String selectedStatus = job.status.toUpperCase();
    if (!['OPEN', 'CLOSED', 'DRAFT'].contains(selectedStatus)) {
      selectedStatus = 'OPEN';
    }

    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: Get.height * 0.6,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Update Job',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTextField('Job Title', titleController),
                      const SizedBox(height: 12),
                      _buildTextField('Description', descriptionController, maxLines: 3),
                      const SizedBox(height: 12),
                      
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'OPEN', child: Text('Open')),
                          DropdownMenuItem(value: 'CLOSED', child: Text('Closed')),
                          DropdownMenuItem(value: 'DRAFT', child: Text('Draft')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() { selectedStatus = val; });
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.isEmpty) {
                            Get.snackbar('Error', 'Please enter a title');
                            return;
                          }
                          bool success = await controller.updateJob(
                            id: job.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            status: selectedStatus,
                          );
                          if (success) {
                            Get.back();
                            Get.snackbar('Success', 'Job updated successfully');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Update Job', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildApplicantCard(String appId, String name, String email, String date, String field, String status) {
    Color statusColor;
    switch (status) {
      case 'Interview':
      case 'Screening': 
        statusColor = Colors.orange; 
        break;
      case 'Offer':
      case 'Hired':
      case 'Accepted': 
        statusColor = Colors.green; 
        break;
      case 'Rejected': 
        statusColor = Colors.red; 
        break;
      case 'Pending':
      case 'Applied':
      default: 
        statusColor = Colors.blue; 
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text("$field   $email", style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text("Applied: $date", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onSelected: (newStatus) async {
              final controller = Get.find<RecruitmentController>();
              bool success = await controller.updateJobApplicationStatus(appId, newStatus);
              if (success) {
                Get.snackbar('Success', 'Status updated successfully');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'APPLIED', child: Text('Applied')),
              const PopupMenuItem(value: 'SCREENING', child: Text('Screening')),
              const PopupMenuItem(value: 'INTERVIEW', child: Text('Interview')),
              const PopupMenuItem(value: 'OFFER', child: Text('Offer')),
              const PopupMenuItem(value: 'HIRED', child: Text('Hired')),
              const PopupMenuItem(value: 'REJECTED', child: Text('Rejected')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceProgress(String title, int count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text("$count%", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: count / 100,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActivityTimeline(String title, String subtitle, String time, IconData icon, Color color, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            Container(
              width: 2,
              height: 40,
              color: AppColors.border,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}






