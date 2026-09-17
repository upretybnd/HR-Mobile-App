class DepartmentIdResponse {
  final bool success;
  final DepartmentIdModel data;
  final String message;

  DepartmentIdResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory DepartmentIdResponse.fromJson(Map<String, dynamic> json) {
    return DepartmentIdResponse(
      success: json['success'] as bool? ?? false,
      data: DepartmentIdModel.fromJson(
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

class DepartmentIdModel {
  final String id;
  final String name;
  final String description;
  final String? managerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DepartmentCountModel count;
  final ManagerModel? manager;
  final List<dynamic> employees;

  DepartmentIdModel({
    required this.id,
    required this.name,
    required this.description,
    this.managerId,
    required this.createdAt,
    required this.updatedAt,
    required this.count,
    this.manager,
    required this.employees,
  });

  factory DepartmentIdModel.fromJson(Map<String, dynamic> json) {
    return DepartmentIdModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      managerId: json['managerId'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      count: DepartmentCountModel.fromJson(
          json['_count'] as Map<String, dynamic>? ?? {}),
      manager: json['manager'] != null
          ? ManagerModel.fromJson(json['manager'] as Map<String, dynamic>)
          : null,
      employees: (json['employees'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'managerId': managerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_count': count.toJson(),
      'manager': manager?.toJson(),
      'employees': employees,
    };
  }
}

class DepartmentCountModel {
  final int employees;

  DepartmentCountModel({required this.employees});

  factory DepartmentCountModel.fromJson(Map<String, dynamic> json) {
    return DepartmentCountModel(
      employees: json['employees'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employees': employees,
    };
  }
}

class ManagerModel {
  final String id;
  final String userId;
  final String employeeId;
  final String departmentId;
  final String position;
  final String employeeType;
  final DateTime joinDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ManagerUserModel user;

  ManagerModel({
    required this.id,
    required this.userId,
    required this.employeeId,
    required this.departmentId,
    required this.position,
    required this.employeeType,
    required this.joinDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
      position: json['position'] as String? ?? '',
      employeeType: json['employeeType'] as String? ?? '',
      joinDate: DateTime.tryParse(json['joinDate'] as String? ?? '') ??
          DateTime.now(),
      status: json['status'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      user: ManagerUserModel.fromJson(
          json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'employeeId': employeeId,
      'departmentId': departmentId,
      'position': position,
      'employeeType': employeeType,
      'joinDate': joinDate.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class ManagerUserModel {
  final String id;
  final String firstName;
  final String lastName;

  ManagerUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ManagerUserModel.fromJson(Map<String, dynamic> json) {
    return ManagerUserModel(
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