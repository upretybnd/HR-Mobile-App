class UsersGroupedModel {
  final bool success;
  final UsersGroupedData? data;
  final String? message;

  UsersGroupedModel({
    required this.success,
    this.data,
    this.message,
  });

  factory UsersGroupedModel.fromJson(Map<String, dynamic> json) {
    return UsersGroupedModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? UsersGroupedData.fromJson(json['data'])
          : null,
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

class UsersGroupedData {
  final List<GroupedUser> employee;
  final List<GroupedUser> intern;
  final List<GroupedUser> superAdmin;
  final List<GroupedUser> hr;
  final List<GroupedUser> admin;

  UsersGroupedData({
    this.employee = const [],
    this.intern = const [],
    this.superAdmin = const [],
    this.hr = const [],
    this.admin = const [],
  });

  /// All users from every role in a single flat list.
  List<GroupedUser> get allUsers =>
      [...superAdmin, ...admin, ...hr, ...employee, ...intern];

  static List<GroupedUser> _parseList(dynamic list) {
    if (list is! List) return [];
    return list
        .map((e) => GroupedUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  factory UsersGroupedData.fromJson(Map<String, dynamic> json) {
    return UsersGroupedData(
      employee: _parseList(json['EMPLOYEE']),
      intern: _parseList(json['INTERN']),
      superAdmin: _parseList(json['SUPER_ADMIN']),
      hr: _parseList(json['HR']),
      admin: _parseList(json['ADMIN']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EMPLOYEE': employee.map((e) => e.toJson()).toList(),
      'INTERN': intern.map((e) => e.toJson()).toList(),
      'SUPER_ADMIN': superAdmin.map((e) => e.toJson()).toList(),
      'HR': hr.map((e) => e.toJson()).toList(),
      'ADMIN': admin.map((e) => e.toJson()).toList(),
    };
  }
}

class GroupedUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final DateTime? createdAt;

  GroupedUser({
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

  factory GroupedUser.fromJson(Map<String, dynamic> json) {
    return GroupedUser(
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