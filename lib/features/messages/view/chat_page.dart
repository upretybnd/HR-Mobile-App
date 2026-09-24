import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/features/messages/api/chat_room_api.dart';
import 'package:hr_management/features/messages/controller/chat_room_controller.dart';
import 'package:hr_management/features/messages/model/chat_room_id_model.dart';
import 'package:hr_management/features/profile/profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_management/features/employee/model/employee_model.dart';
import 'package:hr_management/features/employee/controller/employee_controller.dart';
import 'package:hr_management/features/messages/view/chat_info_page.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String title;
  final String initials;
  final String status;
  final Color avatarColor;
  final bool isGroup;
  final List<Map<String, dynamic>>? initialMessages;

  const ChatPage({
    super.key,
    required this.roomId,
    this.title = 'Engineering Dept',
    this.initials = 'ED',
    this.status = '12 Online',
    this.avatarColor = AppColors.primary,
    this.isGroup = true,
    this.initialMessages,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  late String _currentTitle;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
    _currentStatus = widget.status;
    _fetchMessages();
  }





  Future<void> _fetchMessages() async {
    try {
      if (widget.initialMessages != null) {
        setState(() {
          _messages = List<Map<String, dynamic>>.from(widget.initialMessages!);
          _isLoading = false;
        });
        return;
      }

      final profileController = Get.isRegistered<ProfileController>() 
          ? Get.find<ProfileController>() 
          : Get.put(ProfileController());
      if (profileController.user.value == null) {
        await profileController.fetchUserProfile();
      }
      final myUserId = profileController.user.value?.id;

      final response = await Get.find<ChatRoomController>().getMessages(widget.roomId);
      
      // The API now returns messages in response.data.data
      final List<ChatMessageModel> apiMessages = response.data.data;

      // We don't get the room name from this endpoint anymore, so keep the widget title
      final String fetchedTitle = widget.title;
      final String fetchedStatus = widget.status;

      final List<Map<String, dynamic>> parsedMessages = apiMessages.map<Map<String, dynamic>>((msg) {
        // Correct logic to check if outgoing:
        final bool isOutgoing = myUserId != null && msg.senderId == myUserId; 
        
        final String timeStr = DateFormat('hh:mm a').format(msg.createdAt);
        final String senderName = msg.sender.fullName;
        final String senderInitials = senderName.isNotEmpty ? senderName.substring(0, 1).toUpperCase() : '?';

        return <String, dynamic>{
          'isOutgoing': isOutgoing,
          'senderInitials': senderInitials,
          'senderName': senderName,
          'senderColor': widget.avatarColor,
          'text': msg.content,
          'time': timeStr,
          'createdAt': msg.createdAt,
        };
      }).toList();

      setState(() {
        _currentTitle = fetchedTitle;
        _currentStatus = fetchedStatus;
        _messages = parsedMessages;
        _isLoading = false;
      });
      
      debugPrint('Messages Fetched: ${parsedMessages.length}');
      _scrollToBottom();
    } catch (e) {
      debugPrint('Failed to load messages: $e');
      setState(() {
        _messages = <Map<String, dynamic>>[];
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = '$hour:$minute $period';

    // Eagerly update UI
    setState(() {
      _messages.add(<String, dynamic>{
        'isOutgoing': true,
        'senderInitials': '',
        'senderName': 'You',
        'text': text,
        'time': timeStr,
        'createdAt': DateTime.now(),
      });
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      await Get.find<ChatRoomController>().sendMessage(widget.roomId, text);
      // Refetch chat rooms to ensure parent MessagePage gets updated preview
      if (Get.isRegistered<ChatRoomController>()) {
        Get.find<ChatRoomController>().fetchChatRooms();
      }
    } catch (e) {
      debugPrint('Failed to post message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildChatAppBar(),
      body: SafeArea(
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Scrollable Conversation Area
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                children: [
                  // Message Items
                  for (int i = 0; i < _messages.length; i++) ...[
                    if (_shouldShowDateSeparator(i)) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _buildDateBadge(_getDateLabel(_messages[i]['createdAt'] as DateTime?)),
                      const SizedBox(height: 16),
                    ],
                    _buildMessageBubble(_messages[i]),
                    if (i < _messages.length - 1) const SizedBox(height: 10),
                  ],
                ],
              ),
            ),

            // Fixed Bottom Message Composer
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }

  /// Compact clean AppBar with back button, avatar, title & online status
  PreferredSizeWidget _buildChatAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Row(
          children: [
            // Back Arrow Button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              onPressed: () => Get.back(),
            ),
            const SizedBox(width: 2),

            // Tappable Area for Group/Private Info
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ChatInfoPage(
                    title: _currentTitle,
                    initials: widget.initials,
                    avatarColor: widget.avatarColor,
                    isGroup: widget.isGroup,
                    roomId: widget.roomId,
                  ))?.then((_) {
                    _fetchMessages();
                  });
                },
                child: Container(
                  color: Colors.transparent, // Ensures the entire row area is clickable
                  child: Row(
                    children: [
                      // Small circular green avatar with initials
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: widget.avatarColor,
                        child: Text(
                          widget.initials,
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      
                      // Title and Status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _currentStatus,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
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
            ),
          ],
        ),
      ),
      actions: [
        if (widget.isGroup)
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: AppColors.primary),
            onPressed: () {
              Get.bottomSheet(
                AddMemberBottomSheet(roomId: widget.roomId),
                isScrollControlled: true,
              ).whenComplete(() {
                _fetchMessages();
              });
            },
          ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.border,
          height: 1.0,
        ),
      ),
    );
  }

  bool _shouldShowDateSeparator(int index) {
    if (index == 0) return true; // Always show for the first message
    
    final currentMsg = _messages[index];
    final prevMsg = _messages[index - 1];
    
    final currentDt = currentMsg['createdAt'] as DateTime?;
    final prevDt = prevMsg['createdAt'] as DateTime?;
    
    if (currentDt == null || prevDt == null) return false;
    
    return currentDt.year != prevDt.year || 
           currentDt.month != prevDt.month || 
           currentDt.day != prevDt.day;
  }

  String _getDateLabel(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);
    
    if (msgDate == today) {
      return 'TODAY';
    } else if (msgDate == yesterday) {
      return 'YESTERDAY';
    } else if (now.difference(msgDate).inDays < 7 && now.difference(msgDate).inDays > 0) {
      return DateFormat('EEEE').format(date).toUpperCase();
    } else {
      return DateFormat('d MMMM yyyy').format(date).toUpperCase();
    }
  }

  /// Small rounded light-gray "TODAY" date label centered horizontally
  Widget _buildDateBadge(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  /// Message Bubble widget handling both incoming and outgoing messages
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isOutgoing = message['isOutgoing'] as bool;
    final String text = message['text'] as String;
    final String time = message['time'] as String;
    final String senderInitials = (message['senderInitials'] ?? '') as String;
    final String senderName = (message['senderName'] ?? '') as String;
    final Color senderColor = (message['senderColor'] as Color?) ?? widget.avatarColor;

    final screenWidth = MediaQuery.of(context).size.width;
    final maxBubbleWidth = screenWidth * 0.74;

    if (isOutgoing) {
      // Outgoing message (aligned to the right, dark green bubble, white text)
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          margin: const EdgeInsets.only(left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textWhite,
                  height: 1.35,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textWhite.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Incoming message (aligned to the left, avatar + light-gray bubble, dark text)
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Avatar for the sender
            CircleAvatar(
              radius: 15,
              backgroundColor: senderColor.withValues(alpha: 0.15),
              child: Text(
                senderInitials.isNotEmpty ? senderInitials : widget.initials,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: senderColor,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Message Bubble
            Container(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show sender name in group chats (Department & Project channels)
                  if (widget.isGroup && senderName.isNotEmpty) ...[
                    Text(
                      senderName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: senderColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                  ],
                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          time,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Fixed bottom composer with rounded input, attachment icon and send button
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Attachment Icon
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.textSecondary, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: () {},
          ),
          const SizedBox(width: 4),

          // Rounded Light-Gray Input Field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: AppColors.disabledText, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Circular Green Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddMemberBottomSheet extends StatelessWidget {
  final String roomId;
  
  const AddMemberBottomSheet({Key? key, required this.roomId}) : super(key: key);

  void _addMember(Employee emp) async {
    final userId = emp.userId;
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    if (Get.isRegistered<ChatRoomController>()) {
      final controller = Get.find<ChatRoomController>();
      await controller.addMemberToChat(roomId, userId, firstName: emp.user?.firstName, email: emp.user?.email);
    }
    
    Get.back(); // close loading dialog
    // Deliberately NOT closing the bottom sheet so multiple can be added!
    Get.snackbar('Success', 'Added ${emp.user?.firstName ?? 'Member'} to chat', backgroundColor: Colors.green.withValues(alpha: 0.1));
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
          const Text('Add Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          TextField(
            onChanged: empController.onSearch,
            decoration: InputDecoration(
              hintText: 'Search employees...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (empController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Filter out members that are already in the room
              final chatController = Get.isRegistered<ChatRoomController>() ? Get.find<ChatRoomController>() : null;
              final room = chatController?.chatRooms.firstWhereOrNull((r) => r.id == roomId);
              
              final unaddedEmployees = empController.filteredEmployees.where((emp) {
                final isAlreadyMember = room?.participantIds?.contains(emp.userId) == true || room?.participantIds?.contains(emp.id) == true;
                return !isAlreadyMember;
              }).toList();
              
              if (unaddedEmployees.isEmpty) {
                return const Center(child: Text('No employees found to add.'));
              }
              
              return ListView.builder(
                itemCount: unaddedEmployees.length,
                itemBuilder: (context, index) {
                  final emp = unaddedEmployees[index];
                  final name = empController.getDisplayName(emp);
                  final initial = empController.getInitials(emp);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Text(initial, style: const TextStyle(color: AppColors.primaryDark)),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(empController.getRoleDept(emp), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                      onPressed: () => _addMember(emp),
                    ),
                  );
                }
              );
            })
          )
        ],
      )
    );
  }
}
