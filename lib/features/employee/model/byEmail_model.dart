class ByEmailModel {
  final bool success;
  final ByEmailData? data;
  final String? message;

  ByEmailModel({
    required this.success,
    this.data,
    this.message,
  });

  factory ByEmailModel.fromJson(Map<String, dynamic> json) {
    return ByEmailModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? ByEmailData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class ByEmailData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final DateTime? createdAt;

  ByEmailData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.avatar,
    required this.isActive,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ByEmailData.fromJson(Map<String, dynamic> json) {
    return ByEmailData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'phone': phone,
      'avatar': avatar,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}