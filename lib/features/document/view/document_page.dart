import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';
import 'package:hr_management/features/document/controller/files_controller.dart';
import 'package:hr_management/features/document/model/files_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final FilesController filesController = Get.put(FilesController());
  int _selectedDocIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showAppBar: true,
      showBackButton: true,
      showHeader: true,
      title: 'HR Management',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reusable Search Bar from core
            SearchBarWidget(
              hintText: 'Search Documentation...',
              onChanged: (val) => filesController.searchQuery.value = val,
            ),
            const SizedBox(height: 16),

            // Storage Capacity Card
            _buildStorageCapacityCard(),
            const SizedBox(height: 20),

            // Directories Section
            _buildDirectoriesSection(),
            const SizedBox(height: 20),

            // Recent Documents Section
            _buildRecentDocumentsSection(),
            const SizedBox(height: 14),

            // View All Documents Button
            _buildViewAllButton(),
            const SizedBox(height: 18),

            // Automate Compliance Card
            _buildAutomateComplianceCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          filesController.showUploadDialog();
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Storage Capacity card with progress indicator and 3 distributed stats
  Widget _buildStorageCapacityCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Storage Capacity',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '72% Used',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 8,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: 16),

          // Three Evenly Distributed Statistics
          Row(
            children: [
              Expanded(
                child: _buildStorageStatItem('EMPLOYEE', '1.2 TB'),
              ),
              Container(
                height: 28,
                width: 1,
                color: AppColors.divider,
              ),
              Expanded(
                child: _buildStorageStatItem('INTERN', '450 GB'),
              ),
              Container(
                height: 28,
                width: 1,
                color: AppColors.divider,
              ),
              Expanded(
                child: _buildStorageStatItem('ORG-WIDE', '120 GB'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Directories section with two equal-width directory cards side by side
  Widget _buildDirectoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Directories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Employee Files Directory Card
            Expanded(
              child: _buildDirectoryCard(
                icon: Icons.folder_rounded,
                title: 'Employee Files',
                fileCount: '1,248 Files',
                actionText: 'Explore →',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),

            // Intern Storage Directory Card
            Expanded(
              child: _buildDirectoryCard(
                icon: Icons.folder_special_rounded,
                title: 'Intern Storage',
                fileCount: '312 Files',
                actionText: 'Review Docs →',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectoryCard({
    required IconData icon,
    required String title,
    required String fileCount,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Folder Icon Container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),

            // Directory Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),

            // File Count
            Text(
              fileCount,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Action Link
            Text(
              actionText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recent Documents section with heading, filter action, and vertical cards
  Widget _buildRecentDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row: "Recent Documents" + "Filter"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Documents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: const [
                    Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Vertical Document Cards List
        Obx(() {
          if (filesController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (filesController.errorMessage.isNotEmpty) {
            return Center(child: Text(filesController.errorMessage.value, style: const TextStyle(color: Colors.red)));
          }
          if (filesController.filteredFiles.isEmpty) {
            return const Center(child: Text("No documents found."));
          }
          final recentFiles = filesController.filteredFiles.take(2).toList();
          return Column(
            children: [
              for (int i = 0; i < recentFiles.length; i++) ...[
                _buildDocumentCard(recentFiles[i], index: i),
                if (i < recentFiles.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDocumentCard(FileData doc, {required int index}) {
    final bool isSelected = _selectedDocIndex == index;
    final String title = doc.fileName;
    // Derive category/icon/color from MIME type or file extension
    String category = 'DOCUMENT';
    IconData icon = Icons.description_outlined;
    Color color = AppColors.primary;
    
    if (doc.mimeType.contains('pdf') || doc.fileName.toLowerCase().endsWith('.pdf')) {
      category = 'PDF';
      icon = Icons.picture_as_pdf_outlined;
      color = AppColors.secondary;
    } else if (doc.mimeType.contains('image')) {
      category = 'IMAGE';
      icon = Icons.image_outlined;
      color = AppColors.info;
    } else if (doc.mimeType.contains('spreadsheet') || doc.fileName.toLowerCase().endsWith('.xlsx') || doc.fileName.toLowerCase().endsWith('.csv')) {
      category = 'SPREADSHEET';
      icon = Icons.grid_on_outlined;
      color = AppColors.warning;
    }

    // Format size
    String sizeStr;
    if (doc.fileSize > 1024 * 1024) {
      sizeStr = '${(doc.fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (doc.fileSize > 1024) {
      sizeStr = '${(doc.fileSize / 1024).toStringAsFixed(0)} KB';
    } else {
      sizeStr = '${doc.fileSize} B';
    }

    final String dateStr = DateFormat('MMM d, yyyy').format(doc.createdAt);
    final String metadata = 'Uploaded • $dateStr • $sizeStr';

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDocIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.border,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thin green vertical accent line for first/selected document
                if (isSelected)
                  Container(
                    width: 4,
                    color: AppColors.primary,
                  ),

                // Card Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Row: Icon, Filename & Category Badge, Actions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Colored File Icon
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                icon,
                                color: color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Filename & Category Badge
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Small Action Icons: View, Download, Delete
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined),
                                  iconSize: 18,
                                  color: AppColors.textSecondary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.file_download_outlined),
                                  iconSize: 18,
                                  color: AppColors.textSecondary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  onPressed: () {
                                    filesController.downloadFile(doc.id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  iconSize: 18,
                                  color: AppColors.textSecondary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  onPressed: () {
                                    filesController.deleteFile(doc.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Subtle Metadata at the bottom of the card
                        Padding(
                          padding: const EdgeInsets.only(left: 38.0),
                          child: Text(
                            metadata,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Full-width outlined rounded button: View All Documents (1,644)
  Widget _buildViewAllButton() {
    return Obx(() {
      final totalDocs = filesController.filteredFiles.length;
      return InkWell(
        onTap: () => _showAllDocumentsBottomSheet(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary,
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'View All Documents ($totalDocs)',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
          ),
        ),
      );
    });
  }

  void _showAllDocumentsBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (filesController.filteredFiles.isEmpty) {
                  return const Center(child: Text("No documents found."));
                }
                return ListView.builder(
                  itemCount: filesController.filteredFiles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildDocumentCard(filesController.filteredFiles[index], index: index),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  /// Prominent green "Automate Compliance" card
  Widget _buildAutomateComplianceCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shield Icon and Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Automate Compliance',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Short descriptive text
          Text(
            'Schedule automated audits and ensure all staff contracts, policies, and certifications meet current compliance standards.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // White rounded "Run Audit Now" button with green text & icon ss
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.play_circle_fill_rounded,
                    color: AppColors.primaryDark,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Run Audit Now',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}









