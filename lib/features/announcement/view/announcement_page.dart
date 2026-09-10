import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';
import 'package:hr_management/core/widgets/search_bar_widget.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _announcements = [
    {
      'id': '1',
      'priority': 'PINNED',
      'title': 'Office Closure Notice - Eid Public Holiday',
      'time': '2 hours ago',
      'description':
          'Please be informed that the office will remain closed on June 17, 2026, in observance of the public holiday. Regular operations will resume the following day.',
      'authorName': 'Sarah Jenkins',
      'authorRole': 'HR Director • HR',
      'authorInitials': 'SJ',
      'category': 'General',
      'avatarColor': AppColors.primary,
    },
    {
      'id': '2',
      'priority': 'URGENT',
      'title': 'Scheduled Network & Server Maintenance',
      'time': '5 hours ago',
      'description':
          'The IT department will conduct emergency server maintenance tonight from 10:00 PM to 2:00 AM. Core services, VPN, and internal portals will be temporarily inaccessible.',
      'authorName': 'Marcus Holloway',
      'authorRole': 'Senior Systems Lead • IT',
      'authorInitials': 'MH',
      'category': 'IT Support',
      'avatarColor': AppColors.secondary,
    },
    {
      'id': '3',
      'priority': 'NORMAL',
      'title': 'Quarterly All-Hands Meeting & Review',
      'time': 'Yesterday',
      'description':
          'Join us this Friday at 3:00 PM in the Main Conference Hall and via Zoom for our quarterly company progress review, task highlights, and team recognition.',
      'authorName': 'David Miller',
      'authorRole': 'Operations Lead • Operations',
      'authorInitials': 'DM',
      'category': 'General',
      'avatarColor': AppColors.info,
    },
    {
      'id': '4',
      'priority': 'NORMAL',
      'title': 'Updated Health & Wellness Benefits Package',
      'time': 'June 03, 2026',
      'description':
          'We are pleased to introduce expanded medical coverage and an annual wellness stipend for all full-time employees. Check your email for enrollment details.',
      'authorName': 'Elena Rodriguez',
      'authorRole': 'Benefits Specialist • HR',
      'authorInitials': 'ER',
      'category': 'HR',
      'avatarColor': AppColors.warning,
    },
    {
      'id': '5',
      'priority': 'NORMAL',
      'title': 'Mandatory Cybersecurity Refresher Module',
      'time': 'May 28, 2026',
      'description':
          'All staff members are requested to complete the 15-minute cybersecurity refresher training on the HR portal by the end of this week.',
      'authorName': 'James Wilson',
      'authorRole': 'Security Analyst • IT Support',
      'authorInitials': 'JW',
      'category': 'IT Support',
      'avatarColor': AppColors.primaryDark,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAnnouncements {
    return _announcements.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item['category'] == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          item['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['description'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['authorName'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showAppBar: true,
      showHeader: true,
      title: 'HR Management',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
                  SearchBarWidget(
                    hintText: 'Search announcements...',
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  // Filter Row with Filter Button & Category Chips
                  _buildFilterRow(),
                  const SizedBox(height: 20),

                  // Section Header with count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Announcements',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_filteredAnnouncements.length} posted',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Announcement List
                  if (_filteredAnnouncements.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredAnnouncements.length,
                      itemBuilder: (context, index) {
                        return _buildAnnouncementCard(_filteredAnnouncements[index]);
                      },
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      }

  Widget _buildFilterRow() {
    final categories = ['All', 'General', 'IT Support', 'HR'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Filter Icon Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.tune, size: 16, color: AppColors.textPrimary),
                SizedBox(width: 4),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Category Chips
          ...categories.map((cat) {
            final isSelected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> item) {
    final priority = item['priority'] as String;
    final color = item['avatarColor'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Priority Badge and Date/Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriorityBadge(priority),
              const SizedBox(width: 4),
              Text(
                item['time'],
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Announcement Title
          Text(
            item['title'],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            item['description'],
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Divider
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),

          // Author & Category Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Author Avatar and Details
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: color.withValues(alpha: 0.1),
                      child: Text(
                        item['authorInitials'],
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['authorName'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            item['authorRole'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item['category'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color bgColor;
    Color textColor;
    IconData? icon;

    switch (priority.toUpperCase()) {
      case 'URGENT':
        bgColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case 'PINNED':
        bgColor = const Color(0xFF8B5CF6).withValues(alpha: 0.1);
        textColor = const Color(0xFF8B5CF6);
        icon = Icons.push_pin_outlined;
        break;
      case 'NORMAL':
      default:
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        icon = null;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.campaign_outlined, size: 48, color: AppColors.disabledText),
          const SizedBox(height: 12),
          const Text(
            'No announcements found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try clearing your search or selecting a different category filter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // void _showCreateAnnouncementDialog(BuildContext context) {
  //   final titleController = TextEditingController();
  //   final descController = TextEditingController();
  //   String priority = 'NORMAL';
  //   String category = 'General';
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (ctx) {
  //       return StatefulBuilder(
  //         builder: (context, setModalState) {
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               left: 20,
  //               right: 20,
  //               top: 20,
  //               bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     const Text(
  //                       'New Announcement',
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColors.textPrimary,
  //                       ),
  //                     ),
  //                     IconButton(
  //                       icon: const Icon(Icons.close, size: 20),
  //                       onPressed: () => Navigator.pop(ctx),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 14),
  //                 TextField(
  //                   controller: titleController,
  //                   decoration: InputDecoration(
  //                     hintText: 'Announcement Title',
  //                     filled: true,
  //                     fillColor: AppColors.surface,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide.none,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 TextField(
  //                   controller: descController,
  //                   maxLines: 3,
  //                   decoration: InputDecoration(
  //                     hintText: 'Announcement details / description...',
  //                     filled: true,
  //                     fillColor: AppColors.surface,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide.none,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 14),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: DropdownButtonFormField<String>(
  //                         value: priority,
  //                         decoration: InputDecoration(
  //                           labelText: 'Priority',
  //                           filled: true,
  //                           fillColor: AppColors.surface,
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: BorderSide.none,
  //                           ),
  //                         ),
  //                         items: const [
  //                           DropdownMenuItem(value: 'NORMAL', child: Text('Normal')),
  //                           DropdownMenuItem(value: 'PINNED', child: Text('Pinned')),
  //                           DropdownMenuItem(value: 'URGENT', child: Text('Urgent')),
  //                         ],
  //                         onChanged: (val) {
  //                           if (val != null) {
  //                             setModalState(() => priority = val);
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: DropdownButtonFormField<String>(
  //                         value: category,
  //                         decoration: InputDecoration(
  //                           labelText: 'Category',
  //                           filled: true,
  //                           fillColor: AppColors.surface,
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: BorderSide.none,
  //                           ),
  //                         ),
  //                         items: const [
  //                           DropdownMenuItem(value: 'General', child: Text('General')),
  //                           DropdownMenuItem(value: 'IT Support', child: Text('IT Support')),
  //                           DropdownMenuItem(value: 'HR', child: Text('HR')),
  //                         ],
  //                         onChanged: (val) {
  //                           if (val != null) {
  //                             setModalState(() => category = val);
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //                 SizedBox(
  //                   width: double.infinity,
  //                   height: 48,
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: AppColors.primary,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     onPressed: () {
  //                       if (titleController.text.trim().isNotEmpty) {
  //                         setState(() {
  //                           _announcements.insert(0, {
  //                             'id': DateTime.now().millisecondsSinceEpoch.toString(),
  //                             'priority': priority,
  //                             'title': titleController.text.trim(),
  //                             'time': 'Just now',
  //                             'description': descController.text.trim().isEmpty
  //                                 ? 'No additional description provided.'
  //                                 : descController.text.trim(),
  //                             'authorName': 'Deepak Giri',
  //                             'authorRole': 'HR Admin • Management',
  //                             'authorInitials': 'DG',
  //                             'category': category,
  //                             'avatarColor': AppColors.primaryDark,
  //                           });
  //                         });
  //                         Navigator.pop(ctx);
  //                       }
  //                     },
  //                     child: const Text(
  //                       'Post Announcement',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}