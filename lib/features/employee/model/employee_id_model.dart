class EmployeeIdResponse {
  final bool success;
  final EmployeeIdModel data;
  final String message;

  EmployeeIdResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory EmployeeIdResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeIdResponse(
      success: json['success'] as bool,
      data: EmployeeIdModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
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

class EmployeeIdModel {
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
  final User user;
  final Department department;

  EmployeeIdModel({
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

  factory EmployeeIdModel.fromJson(Map<String, dynamic> json) {
    return EmployeeIdModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      employeeId: json['employeeId'] as String,
      departmentId: json['departmentId'] as String,
      position: json['position'] as String,
      employeeType: json['employeeType'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      department: Department.fromJson(json['department'] as Map<String, dynamic>),
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

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
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

  String get fullName => '$firstName $lastName';
}

class Department {
  final String id;
  final String name;
  final String description;
  final String managerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.managerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      managerId: json['managerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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