import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hr_management/features/document/api/files_api.dart';
import 'package:hr_management/features/document/model/files_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hr_management/core/utils/app_colors.dart';

class FilesController extends GetxController {
  final isLoading = true.obs;
  final files = <FileData>[].obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  List<FileData> get filteredFiles {
    if (searchQuery.value.isEmpty) return files;
    return files.where((f) => f.fileName.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await FilesApi.fetchFiles();
      if (result.success) {
        files.assignAll(result.data);
      } else {
        errorMessage(result.message);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Downloads a file by:
  /// 1. Re-fetching file list for a fresh download token
  /// 2. Downloading the file in-app with both Auth header + token query param
  /// 3. Saving to device and opening it
  Future<void> downloadFile(String fileId) async {
    try {
      // Step 1: Re-fetch files to get a fresh download token
      final freshResult = await FilesApi.fetchFiles();
      if (!freshResult.success) {
        Get.snackbar('Error', freshResult.message, snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final file = freshResult.data.firstWhere(
        (f) => f.id == fileId,
        orElse: () => throw Exception('File not found'),
      );

      // Step 2: Get the save directory
      final dir = await getTemporaryDirectory();
      final savePath = '${dir.path}/${file.fileName}';

      // Step 3: Show downloading snackbar
      Get.snackbar(
        'Downloading',
        file.fileName,
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
        duration: const Duration(seconds: 10),
      );

      // Step 4: Download the file with both auth header + download token in URL
      await FilesApi.downloadFile(
        downloadUrl: file.downloadUrl,
        savePath: savePath,
      );

      // Step 5: Close the downloading snackbar and show success
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.snackbar(
        'Downloaded',
        file.fileName,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => OpenFilex.open(savePath),
          child: const Text('OPEN', style: TextStyle(color: Colors.white)),
        ),
        duration: const Duration(seconds: 5),
      );

      // Step 6: Automatically open the file
      await OpenFilex.open(savePath);

    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Failed to download: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  final selectedUploadFile = Rx<PlatformFile?>(null);

  void showUploadDialog() {
    selectedUploadFile.value = null; // reset
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Upload Document',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.white, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select a file to upload:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final result = await FilePicker.pickFiles();
                          if (result.isNotEmpty && result.first.path != null) {
                            selectedUploadFile.value = result.first;
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFFCA5A5), width: 1), // matching input border
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file, color: Color(0xFF9CA3AF), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(() => Text(
                                      selectedUploadFile.value?.name ?? 'Browse for file...',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: selectedUploadFile.value != null ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF),
                                        fontSize: 14,
                                        fontWeight: selectedUploadFile.value != null ? FontWeight.w500 : FontWeight.normal,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      const Divider(color: Color(0xFFF3E8E8), height: 1, thickness: 1),
                      const SizedBox(height: 20),
                      
                      // Action Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Obx(() => ElevatedButton(
                                onPressed: selectedUploadFile.value == null
                                    ? null
                                    : () {
                                        Get.back();
                                        _performUpload(selectedUploadFile.value!);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check, color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save Document',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      useSafeArea: true,
    );
  }

  Future<void> _performUpload(PlatformFile file) async {
    try {
      final filePath = file.path!;
      
      Get.snackbar(
        'Uploading',
        'Uploading ${file.name}...',
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
        duration: const Duration(seconds: 10),
      );

      final response = await FilesApi.uploadFile(filePath);
      
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      
      if (response['success'] == true) {
        Get.snackbar('Success', 'File uploaded successfully', snackPosition: SnackPosition.BOTTOM);
        fetchFiles(); // Refresh list
      } else {
        Get.snackbar('Error', response['message'] ?? 'Upload failed', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Failed to upload file: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
  Future<void> deleteFile(String id) async {
    try {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Delete Document',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.white, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Are you sure you want to delete this file? This action cannot be undone.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFF3E8E8), height: 1, thickness: 1),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Color(0xFF4B5563), fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back(); // Close dialog
                              Get.snackbar('Deleting', 'Deleting file...', snackPosition: SnackPosition.BOTTOM);
                              final response = await FilesApi.deleteFile(id);
                              if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

                              if (response['success'] == true) {
                                Get.snackbar('Success', 'File deleted successfully', snackPosition: SnackPosition.BOTTOM);
                                fetchFiles(); // Refresh list
                              } else {
                                Get.snackbar('Error', response['message'] ?? 'Delete failed', snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_outline, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        useSafeArea: true,
      );
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Failed to delete file: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

