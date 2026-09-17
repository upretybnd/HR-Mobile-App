import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/announcement/api/announcement_api.dart';
import 'package:hr_management/features/announcement/model/announcement_model.dart';

class AnnouncementController extends GetxController {
  final announcements = <AnnouncementModel>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  // get announcements call api
  Future<void> fetchAnnouncements() async {
    try {
      isLoading.value = true;
      final response = await AnnouncementApi.getAnnouncement();
      announcements.assignAll(response.data);
    } catch (e) {
      print('Error fetching announcements: $e');
    } finally {
      isLoading.value = false;
    }
  }

// delete announcement call api
  Future<void> deleteAnnouncement(String id) async {
    try {
      await AnnouncementApi.deleteAnnouncementId(id);
      announcements.removeWhere((item) => item.id == id);
      Get.snackbar('Success', 'Announcement deleted successfully',
          backgroundColor: const Color(0xFF22C55E), colorText: const Color(0xFFFFFFFF));
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete announcement',
          backgroundColor: const Color(0xFFEF4444), colorText: const Color(0xFFFFFFFF));
    }
  }

  List<AnnouncementModel> get filteredAnnouncements {
    return announcements.where((item) {
      final matchesSearch = searchQuery.value.isEmpty ||
          item.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          item.content.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          item.author.fullName.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesSearch;
    }).toList();
  }
}
