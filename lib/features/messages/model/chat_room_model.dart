class ChatRoomResponse {
  final bool success;
  final List<ChatRoomModel> data;
  final String message;

  ChatRoomResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ChatRoomResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class ChatRoomModel {
  // --- Confirmed fields from your sample ---
  final String id;
  final String name;
  final String type; // e.g. "GROUP", "PRIVATE"
  final String createdBy;

  // --- Assumed fields (common for chat rooms) — verify/adjust against full payload ---
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int? unreadCount;
  final List<String>? participantIds;
  final List<Map<String, dynamic>>? rawMembers;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount,
    this.participantIds,
    this.rawMembers,
  });

  bool get isGroup => type == 'GROUP';
  bool get isPrivate => type == 'PRIVATE';

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    // Safely extract string from a possible Map
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) {
        return (value['id'] ?? value['name'] ?? value['title'] ?? '').toString();
      }
      return value.toString();
    }

    // Safely extract message text
    String? safeMessage(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map) {
        return (value['content'] ?? value['message'] ?? value['text'])?.toString();
      }
      return value.toString();
    }

    return ChatRoomModel(
      id: safeString(json['id']),
      name: safeString(json['name']),
      type: safeString(json['type']),
      createdBy: safeString(json['createdBy'] ?? json['creator']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      lastMessage: safeMessage(json['lastMessage']),
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
      unreadCount: json['unreadCount'] is int ? json['unreadCount'] : int.tryParse(json['unreadCount']?.toString() ?? ''),
      participantIds: (json['members'] ?? json['participantIds'] ?? json['participants'] as List<dynamic>?)
          ?.map((e) {
            if (e is Map) {
              return (e['userId'] ?? e['id']?.toString() ?? '');
            }
            return e.toString();
          })
          .cast<String>()
          .toList(),
      rawMembers: (json['members'] as List<dynamic>?)
          ?.map((e) {
            if (e is Map) {
              return Map<String, dynamic>.from(e);
            }
            return <String, dynamic>{};
          })
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'unreadCount': unreadCount,
      'participantIds': participantIds,
    };
  }
}