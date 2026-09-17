
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/announcement/api/announcement_api.dart';
import 'package:hr_management/features/announcement/controller/announcement_controller.dart';
import 'package:hr_management/features/announcement/model/announcement_model.dart';


class AnnouncementForm extends StatefulWidget {
  final AnnouncementModel? announcementToEdit;
  
  const AnnouncementForm({super.key, this.announcementToEdit});

  @override
  State<AnnouncementForm> createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  String _selectedPriority = 'NORMAL';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.announcementToEdit != null) {
      _titleController.text = widget.announcementToEdit!.title;
      _contentController.text = widget.announcementToEdit!.content;
      _selectedPriority = widget.announcementToEdit!.priority.toUpperCase();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500), // Responsive max width
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1), // Thin light border
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000), // pale shadow
                  blurRadius: 10,
                  offset: Offset(0, 2), // Fixed offset for a centered card
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dark Green Header
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
                      const Icon(Icons.campaign_outlined, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.announcementToEdit != null ? 'Edit Announcement' : 'New Announcement',
                          style: const TextStyle(
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
                
                // Form Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      const Text(
                        'Announcement Title',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563), // dark gray
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Enter a descriptive title...',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1), // light peach/pink border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Priority Dropdown
                      const Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563), // dark gray
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPriority,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 20),
                            isExpanded: true,
                            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            items: const [
                              DropdownMenuItem(value: 'NORMAL', child: Text('NORMAL')),
                              DropdownMenuItem(value: 'PINNED', child: Text('PINNED')),
                              DropdownMenuItem(value: 'URGENT', child: Text('URGENT')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPriority = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Content / Message Field
                      const Text(
                        'Content / Message',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563), // dark gray
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 5,
                        minLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Write your announcement details here...',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1), // light peach/pink border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Divider
                      const Divider(color: Color(0xFFF3E8E8), height: 1, thickness: 1), // very light peach/gray
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
                                color: Color(0xFF4B5563), // muted dark gray/blue
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    final title = _titleController.text.trim();
                                    final content = _contentController.text.trim();
                                    
                                    if (title.isEmpty || content.isEmpty) {
                                      Get.snackbar('Error', 'Title and Content cannot be empty',
                                          backgroundColor: Colors.red, colorText: Colors.white);
                                      return;
                                    }
                                    
                                    setState(() => _isSubmitting = true);
                                    final isEdit = widget.announcementToEdit != null;
                                    
                                    try {
                                      if (isEdit) {
                                        await AnnouncementApi.updateAnnouncementId(
                                          widget.announcementToEdit!.id,
                                          title,
                                          content,
                                          _selectedPriority,
                                        );
                                      } else {
                                        await AnnouncementApi.postAnnouncement(title, content, _selectedPriority);
                                      }
                                      
                                      // Refresh list
                                      if (Get.isRegistered<AnnouncementController>()) {
                                        Get.find<AnnouncementController>().fetchAnnouncements();
                                      }
                                      
                                      Get.back();
                                      Get.snackbar(
                                        'Success', 
                                        isEdit ? 'Announcement updated successfully' : 'Announcement posted successfully',
                                        backgroundColor: Colors.green, 
                                        colorText: Colors.white,
                                      );
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error', 
                                        isEdit ? 'Failed to update announcement' : 'Failed to post announcement',
                                        backgroundColor: Colors.red, 
                                        colorText: Colors.white,
                                      );
                                    } finally {
                                      if (mounted) setState(() => _isSubmitting = false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isSubmitting)
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                else
                                  const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  widget.announcementToEdit != null ? 'Update Announcement' : 'Publish Announcement',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
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
    );
  }
}
