class EmployeeGroupedResponse {
  final bool success;
  final Map<String, List<EmployeeGroupedItemModel>> data;
  final String message;

  EmployeeGroupedResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory EmployeeGroupedResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>? ?? {};
    final parsedData = <String, List<EmployeeGroupedItemModel>>{};

    rawData.forEach((departmentName, employeeList) {
      parsedData[departmentName] = (employeeList as List<dynamic>? ?? [])
          .map((e) =>
              EmployeeGroupedItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    return EmployeeGroupedResponse(
      success: json['success'] as bool? ?? false,
      data: parsedData,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      'message': message,
    };
  }
}

class EmployeeGroupedItemModel {
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
  final EmployeeGroupedUserModel user;
  final EmployeeGroupedDepartmentModel department;

  EmployeeGroupedItemModel({
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
    required this.department,
  });

  factory EmployeeGroupedItemModel.fromJson(Map<String, dynamic> json) {
    return EmployeeGroupedItemModel(
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
      user: EmployeeGroupedUserModel.fromJson(
          json['user'] as Map<String, dynamic>? ?? {}),
      department: EmployeeGroupedDepartmentModel.fromJson(
          json['department'] as Map<String, dynamic>? ?? {}),
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
      'department': department.toJson(),
    };
  }
}

class EmployeeGroupedUserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? avatar;

  EmployeeGroupedUserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatar,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory EmployeeGroupedUserModel.fromJson(Map<String, dynamic> json) {
    return EmployeeGroupedUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'avatar': avatar,
    };
  }
}

class EmployeeGroupedDepartmentModel {
  final String id;
  final String name;
  final String description;
  final String? managerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmployeeGroupedDepartmentModel({
    required this.id,
    required this.name,
    required this.description,
    this.managerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeGroupedDepartmentModel.fromJson(Map<String, dynamic> json) {
    return EmployeeGroupedDepartmentModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      managerId: json['managerId'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
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
    };
  }
}