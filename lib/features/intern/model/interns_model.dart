class InternsModel {
  final bool success;
  final List<Intern> data;
  final String message;

  InternsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory InternsModel.fromJson(Map<String, dynamic> json) {
    return InternsModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<Intern>.from(
              (json['data'] as List).map((x) => Intern.fromJson(x)))
          : [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
      'message': message,
    };
  }
}

class Intern {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final DateTime? createdAt;
  final dynamic employee;

  Intern({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.avatar,
    required this.isActive,
    this.createdAt,
    this.employee,
  });

  String get fullName => '$firstName $lastName';

  factory Intern.fromJson(Map<String, dynamic> json) {
    return Intern(
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
      employee: json['employee'],
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
      'employee': employee,
    };
  }

  Intern copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? phone,
    String? avatar,
    bool? isActive,
    DateTime? createdAt,
    dynamic employee,
  }) {
    return Intern(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      employee: employee ?? this.employee,
    );
  }
}