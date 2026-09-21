class ChatRoomIdResponse {
  final bool success;
  final ChatRoomIdModel data;
  final String message;

  ChatRoomIdResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ChatRoomIdResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomIdResponse(
      success: json['success'] as bool? ?? false,
      data: ChatRoomIdModel.fromJson(
          json['data'] as Map<String, dynamic>? ?? {}),
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class ChatRoomIdModel {
  final List<ChatMessageModel> data;
  final String? nextCursor;
  final bool hasMore;

  ChatRoomIdModel({
    required this.data,
    this.nextCursor,
    required this.hasMore,
  });

  factory ChatRoomIdModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomIdModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'nextCursor': nextCursor,
      'hasMore': hasMore,
    };
  }
}

class ChatMessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final String type; // e.g. "SYSTEM", "TEXT"
  final DateTime createdAt;
  final ChatMessageSenderModel sender;

  ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.sender,
  });

  bool get isSystem => type == 'SYSTEM';
  bool get isText => type == 'TEXT';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      roomId: json['roomId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      sender: ChatMessageSenderModel.fromJson(
          json['sender'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'sender': sender.toJson(),
    };
  }
}

class ChatMessageSenderModel {
  final String id;
  final String firstName;
  final String lastName;

  ChatMessageSenderModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ChatMessageSenderModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageSenderModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}