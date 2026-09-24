import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/messages/view/chat_page.dart';
import 'package:hr_management/features/messages/controller/chat_room_controller.dart';
import 'package:hr_management/features/messages/model/chat_room_model.dart';
import 'package:hr_management/features/employee/controller/employee_controller.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
import 'package:hr_management/features/profile/profile_controller.dart';
import 'package:intl/intl.dart';

class ChatInfoPage extends StatefulWidget {
  final String roomId;
  final String title;
  final String initials;
  final Color avatarColor;
  final bool isGroup;

  const ChatInfoPage({
    Key? key,
    required this.roomId,
    required this.title,
    required this.initials,
    required this.avatarColor,
    required this.isGroup,
  }) : super(key: key);

  @override
  State<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  ChatRoomModel? roomDetails;
  List<Employee> allEmployees = [];
  List<Employee> members = [];
  Employee? admin;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String? myUserId;



  Future<void> _fetchData() async {
    try {
      final profileController = Get.isRegistered<ProfileController>() 
          ? Get.find<ProfileController>() 
          : Get.put(ProfileController());
      if (profileController.user.value == null) {
        await profileController.fetchUserProfile();
      }
      myUserId = profileController.user.value?.id;

      final controller = Get.find<ChatRoomController>();
      final room = controller.chatRooms.firstWhereOrNull((r) => r.id == widget.roomId);

      final employeeController = Get.isRegistered<EmployeeController>() 
          ? Get.find<EmployeeController>() 
          : Get.put(EmployeeController());
      if (employeeController.employees.isEmpty) {
        await employeeController.fetchEmployees();
      }
      final employees = employeeController.employees;

      if (room != null) {
        if (room.participantIds != null) {
          members = employees.where((emp) => 
            room.participantIds!.contains(emp.userId) || room.participantIds!.contains(emp.id)
          ).toList();
        }
        
        admin = employees.firstWhereOrNull((emp) => emp.userId == room.createdBy || emp.id == room.createdBy);
      }

      setState(() {
        roomDetails = room;
        allEmployees = employees;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeMember(String targetUserId) async {
    try {
      // The backend expects the user ID in the URL: /api/chat/rooms/:roomId/members/:userId
      await Get.find<ChatRoomController>().removeMemberFromChat(widget.roomId, targetUserId);
      
      Get.snackbar('Success', 'Member removed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      // Refresh the controller and this page's data
      await Get.find<ChatRoomController>().fetchChatRooms();
      _fetchData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove member.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = roomDetails?.name.isNotEmpty == true ? roomDetails!.name : widget.title;
    final createdDate = roomDetails?.createdAt != null 
        ? DateFormat('MMMM d, yyyy').format(roomDetails!.createdAt!)
        : 'Unknown Date';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.isGroup ? 'Group Info' : 'Contact Info',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: widget.avatarColor,
              child: Text(
                widget.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title / Name
            Text(
              displayTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Status or Member Count
            Text(
              widget.isGroup ? '${members.length} Members' : 'Active Now',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Group Metadata (Admin & Creation Date)
            if (widget.isGroup)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('Admin: ${admin?.user?.firstName ?? 'Unknown'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Created: $createdDate', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(Icons.search, 'Search', () {}),
                const SizedBox(width: 32),
                _buildActionIcon(Icons.notifications_outlined, 'Mute', () {}),
                if (widget.isGroup) ...[
                  const SizedBox(width: 32),
                  _buildActionIcon(Icons.person_add_alt_1, 'Add', () {
                    Get.bottomSheet(
                      AddMemberBottomSheet(roomId: widget.roomId),
                      isScrollControlled: true,
                    ).whenComplete(_fetchData); // refresh after adding
                  }),
                ],
              ],
            ),
            const SizedBox(height: 32),
            const Divider(height: 1, color: AppColors.border),
            
            if (widget.isGroup) ...[
              // Members list
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Members',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: const Icon(Icons.person_add, color: AppColors.primary),
                      ),
                      title: const Text('Add members', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Get.bottomSheet(
                          AddMemberBottomSheet(roomId: widget.roomId),
                          isScrollControlled: true,
                        ).whenComplete(_fetchData);
                      },
                    ),
                    // Dynamically build list of members using Obx
                    Obx(() {
                      final controller = Get.find<ChatRoomController>();
                      final reactiveRoom = controller.chatRooms.firstWhereOrNull((r) => r.id == widget.roomId);
                      
                      final activeMembers = allEmployees.where((emp) {
                        return reactiveRoom?.participantIds?.contains(emp.userId) == true || 
                               reactiveRoom?.participantIds?.contains(emp.id) == true;
                      }).toList();

                      return Column(
                        children: activeMembers.map((emp) {
                          final name = '${emp.user?.firstName ?? ''}'.trim();
                          final displayName = name.isNotEmpty ? name : 'Unknown';
                          final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
                          final isAdmin = emp.userId == reactiveRoom?.createdBy || emp.id == reactiveRoom?.createdBy;
                          final bool isCurrentUserAdmin = myUserId != null && myUserId == reactiveRoom?.createdBy;

                          Widget? trailingWidget;
                          if (isAdmin) {
                            trailingWidget = Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Admin', style: TextStyle(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                            );
                          } else if (isCurrentUserAdmin) {
                            trailingWidget = IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => _removeMember(emp.userId),
                            );
                          }

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(initial, style: const TextStyle(color: Colors.white)),
                            ),
                            title: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(emp.position, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            trailing: trailingWidget,
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
            ],
            
            if (widget.isGroup) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text(
                    'Leave Group',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    if (myUserId != null) {
                      _removeMember(myUserId!);
                    }
                  },
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
