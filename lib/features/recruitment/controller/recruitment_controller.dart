import 'package:get/get.dart';
import 'package:hr_management/features/recruitment/api/recruitment_api.dart';
import 'package:hr_management/features/recruitment/model/recruitment_model.dart';
import 'package:hr_management/features/recruitment/model/applications_model.dart';
import 'package:hr_management/features/department/api/department_api.dart';
import 'package:hr_management/features/department/model/department_model.dart';
import 'dart:io';

class RecruitmentController extends GetxController {
  final isLoading = true.obs;
  final recruitments = <JobData>[].obs;
  final applications = <ApplicationData>[].obs;
  final departments = <DepartmentModel>[].obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  List<JobData> get filteredRecruitments {
    if (searchQuery.value.isEmpty) return recruitments;
    return recruitments.where((j) => j.title.toLowerCase().contains(searchQuery.value.toLowerCase()) || (j.department?.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchRecruitments();
    fetchApplications();
    fetchDepartments();
  }

  Future<void> fetchRecruitments() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await RecruitmentApi.fetchRecruitment();
      if (result.success) {
        recruitments.assignAll(result.data);
      } else {
        errorMessage(result.message);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDepartments() async {
    try {
      final result = await DepartmentApi.fetchDepartments();
      if (result.success) {
        departments.assignAll(result.data);
      }
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> fetchApplications() async {
    try {
      final result = await RecruitmentApi.fetchApplications();
      if (result.success) {
        applications.assignAll(result.data);
      }
    } catch (e) {
      print('Error fetching applications: $e');
    }
  }

  Future<bool> postJob({
    required String departmentId,
    required String title,
    required String description,
    required String department,
    required String location,
    required String type,
    required String salaryMin,
    required String salaryMax,
  }) async {
    try {
      await RecruitmentApi.postJobs(
        departmentId,
        title,
        description,
        department,
        location,
        type,
        salaryMin,
        salaryMax,
      );
      fetchRecruitments(); // Refresh list after successful post
      return true;
    } catch (e) {
      print('Error posting job: $e');
      Get.snackbar('Error', 'Failed to post job: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
  Future<bool> updateJob({
    required String id,
    required String title,
    required String description,
    required String status,
  }) async {
    try {
      await RecruitmentApi.updateJobs(
        id,
        title,
        description,
        status,
      );
      fetchRecruitments(); // Refresh list after successful update
      return true;
    } catch (e) {
      print('Error updating job: $e');
      Get.snackbar('Error', 'Failed to update job: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> applyJob({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? coverLetter,
    File? resume,
  }) async {
    try {
      await RecruitmentApi.applyJob(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        coverLetter: coverLetter,
        resume: resume,
      );
      fetchApplications(); // Refresh applications list
      return true;
    } catch (e) {
      print('Error applying to job: $e');
      Get.snackbar('Error', 'Failed to submit application: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> updateJobApplicationStatus(String id, String status) async {
    try {
      await RecruitmentApi.patchJobStatus(id, status);
      fetchApplications(); // Refresh applications list
      return true;
    } catch (e) {
      print('Error updating application status: $e');
      Get.snackbar('Error', 'Failed to update status: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}

