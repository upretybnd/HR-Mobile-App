import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/features/messages/view/chat_page.dart';
import 'package:hr_management/features/messages/controller/chat_room_controller.dart';
import 'package:hr_management/features/messages/model/chat_room_model.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
import 'package:hr_management/features/employee/controller/employee_controller.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ChatRoomController controller = Get.put(ChatRoomController());
  int _selectedTab = 0;

  List<ChatRoomModel> get _currentList =>
      _selectedTab == 0 ? controller.groupRooms : controller.privateRooms;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showAppBar: true,
      showBackButton: true,
      showHeader: true,
      title: 'Hr Management',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedTab == 0) {
            _showCreateRoomDialog();
          } else {
            Get.bottomSheet(
              const NewPrivateChatBottomSheet(),
              isScrollControlled: true,
            );
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: Column(
        children: [
          // Segmented Tab / Filter Area
          _buildSegmentedTabs(),

          // Inbox Message List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = _currentList;
              if (list.isEmpty) {
                return const Center(child: Text('No messages found.'));
              }
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.divider,
                  height: 1,
                  indent: 68,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  return _buildMessageRow(list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Departments & Projects Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_selectedTab != 0) {
                  setState(() => _selectedTab = 0);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.primaryDark
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Departments & Projects',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 0
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Private Messages Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_selectedTab != 1) {
                  setState(() => _selectedTab = 1);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.primaryDark
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Private Messages',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 1
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageRow(ChatRoomModel item) {
    final String title = item.name;
    final String initials = title.isNotEmpty ? title.substring(0, 1).toUpperCase() : '?';
    final Color avatarColor = AppColors.primary;
    final String preview = item.lastMessage ?? 'No messages yet';
    final String time = item.lastMessageAt != null
        ? DateFormat('hh:mm a').format(item.lastMessageAt!)
        : '';

    final bool isGroup = item.isGroup;
    final String status = isGroup ? '12 Online' : 'Active Now';

    return InkWell(
      onTap: () {
        Get.to(
          () => ChatPage(
            roomId: item.id,
            title: title,
            initials: initials,
            avatarColor: avatarColor,
            status: status,
            isGroup: isGroup,
          ),
          transition: Transition.noTransition,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Colored Avatar with Initials
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Sender/Group Title, Message Preview & Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Message Preview
                  Text(
                    preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRoomDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    String selectedType = 'GROUP';

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Text(
                'Create Chat Room',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Room Name',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'GROUP', child: Text('Group')),
                DropdownMenuItem(value: 'PRIVATE', child: Text('Private')),
              ],
              onChanged: (val) {
                if (val != null) {
                  selectedType = val;
                }
              },
              decoration: InputDecoration(
                labelText: 'Type',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final name = nameController.text.trim();
              final desc = descController.text.trim();
              if (name.isEmpty) {
                Get.snackbar('Error', 'Room name cannot be empty', backgroundColor: Colors.red.withValues(alpha: 0.1));
                return;
              }

              Get.back(); // close dialog
              
              // show loading
              Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
              
              try {
                final success = await controller.createGroupChat(name, desc, selectedType);
                Get.back(); // close loading
                if (success) {
                  Get.snackbar('Success', 'Chat room created successfully', backgroundColor: Colors.green.withValues(alpha: 0.1));
                }
              } catch (e) {
                Get.back(); // close loading
                Get.snackbar('Error', 'Failed to create chat room', backgroundColor: Colors.red.withValues(alpha: 0.1));
              }
            },
            child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class NewPrivateChatBottomSheet extends StatelessWidget {
  const NewPrivateChatBottomSheet({Key? key}) : super(key: key);

  void _startPrivateChat(Employee emp) async {
    final name = emp.user?.firstName ?? 'Private Chat';
    
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    final ChatRoomController controller = Get.find<ChatRoomController>();
    final roomId = await controller.startPrivateChat(name, emp.userId);
    
    Get.back(); // close loading
    Get.back(); // close bottom sheet
    
    if (roomId != null && roomId.isNotEmpty) {
      Get.to(
        () => ChatPage(
          roomId: roomId,
          title: name,
          initials: name.isNotEmpty ? name[0].toUpperCase() : '?',
          avatarColor: AppColors.primary,
          status: 'Active Now',
          isGroup: false,
        ),
        transition: Transition.noTransition,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Register controller locally if not already done, or just find it
    final EmployeeController empController = Get.isRegistered<EmployeeController>() 
        ? Get.find<EmployeeController>() 
        : Get.put(EmployeeController());
        
    // Reset search on open
    empController.onSearch('');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('New Message', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          TextField(
            onChanged: empController.onSearch,
            decoration: InputDecoration(
              hintText: 'Search people...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (empController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final filteredEmployees = empController.filteredEmployees;
              
              if (filteredEmployees.isEmpty) {
                return const Center(child: Text('No employees found.'));
              }
              
              return ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  final emp = filteredEmployees[index];
                  final name = empController.getDisplayName(emp);
                  final initial = empController.getInitials(emp);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Text(initial, style: const TextStyle(color: AppColors.primaryDark)),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(empController.getRoleDept(emp), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    onTap: () => _startPrivateChat(emp),
                  );
                }
              );
            }),
          )
        ],
      )
    );
  }
}