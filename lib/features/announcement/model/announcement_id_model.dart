class AnnouncementIdResponse {
  final bool success;
  final AnnouncementIdModel data;
  final String message;

  AnnouncementIdResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory AnnouncementIdResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementIdResponse(
      success: json['success'] as bool? ?? false,
      data: AnnouncementIdModel.fromJson(
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

class AnnouncementIdModel {
  final String id;
  final String companyId;
  final String createdBy;
  final String title;
  final String content;
  final String priority;
  final String targetType;
  final String? targetDepartmentId;
  final List<String> targetUserIds;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AuthorModel author;
  final List<AttachmentModel> attachments;

  AnnouncementIdModel({
    required this.id,
    required this.companyId,
    required this.createdBy,
    required this.title,
    required this.content,
    required this.priority,
    required this.targetType,
    this.targetDepartmentId,
    required this.targetUserIds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.attachments,
  });

  factory AnnouncementIdModel.fromJson(Map<String, dynamic> json) {
    // targetUserIds arrives as a JSON-encoded string, e.g. "[]"
    List<String> parsedTargetUserIds = [];
    final rawTargetUserIds = json['targetUserIds'];
    if (rawTargetUserIds is String) {
      final decoded = rawTargetUserIds.trim();
      if (decoded.isNotEmpty && decoded != '[]') {
        parsedTargetUserIds = decoded
            .replaceAll(RegExp(r'[\[\]"]'), '')
            .split(',')
            .where((e) => e.trim().isNotEmpty)
            .map((e) => e.trim())
            .toList();
      }
    } else if (rawTargetUserIds is List) {
      parsedTargetUserIds = rawTargetUserIds.map((e) => e.toString()).toList();
    }

    return AnnouncementIdModel(
      id: json['id'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      priority: json['priority'] as String? ?? 'NORMAL',
      targetType: json['targetType'] as String? ?? 'ALL',
      targetDepartmentId: json['targetDepartmentId'] as String?,
      targetUserIds: parsedTargetUserIds,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      author:
          AuthorModel.fromJson(json['author'] as Map<String, dynamic>? ?? {}),
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'createdBy': createdBy,
      'title': title,
      'content': content,
      'priority': priority,
      'targetType': targetType,
      'targetDepartmentId': targetDepartmentId,
      'targetUserIds': targetUserIds.toString(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'author': author.toJson(),
      'attachments': attachments.map((e) => e.toJson()).toList(),
    };
  }
}

class AuthorModel {
  final String id;
  final String firstName;
  final String lastName;

  AuthorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
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

class AttachmentModel {
  final String? id;
  final String? url;
  final String? name;

  AttachmentModel({this.id, this.url, this.name});

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String?,
      url: json['url'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'name': name,
    };
  }
}