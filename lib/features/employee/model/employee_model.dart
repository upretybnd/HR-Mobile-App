
class EmployeeModel {
  final bool success;
  final List<Employee> data;
  final String message;

  EmployeeModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Employee.fromJson(e as Map<String, dynamic>))
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

enum EmployeeType {
  fullTime,
  partTime,
  contract,
  intern,
  unknown;

  static EmployeeType fromString(String? value) {
    switch (value) {
      case 'FULL_TIME':
        return EmployeeType.fullTime;
      case 'PART_TIME':
        return EmployeeType.partTime;
      case 'CONTRACT':
        return EmployeeType.contract;
      case 'INTERN':
        return EmployeeType.intern;
      default:
        return EmployeeType.unknown;
    }
  }

  String toRawString() {
    switch (this) {
      case EmployeeType.fullTime:
        return 'FULL_TIME';
      case EmployeeType.partTime:
        return 'PART_TIME';
      case EmployeeType.contract:
        return 'CONTRACT';
      case EmployeeType.intern:
        return 'INTERN';
      case EmployeeType.unknown:
        return 'UNKNOWN';
    }
  }
}

enum EmployeeStatus {
  active,
  inactive,
  terminated,
  unknown;

  static EmployeeStatus fromString(String? value) {
    switch (value) {
      case 'ACTIVE':
        return EmployeeStatus.active;
      case 'INACTIVE':
        return EmployeeStatus.inactive;
      case 'TERMINATED':
        return EmployeeStatus.terminated;
      default:
        return EmployeeStatus.unknown;
    }
  }

  String toRawString() {
    switch (this) {
      case EmployeeStatus.active:
        return 'ACTIVE';
      case EmployeeStatus.inactive:
        return 'INACTIVE';
      case EmployeeStatus.terminated:
        return 'TERMINATED';
      case EmployeeStatus.unknown:
        return 'UNKNOWN';
    }
  }
}

class Employee {
  final String id;
  final String userId;
  final String employeeId;
  final String departmentId;
  final String position;
  final EmployeeType employeeType;
  final DateTime joinDate;
  final EmployeeStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EmployeeUser? user;
  final EmployeeDepartment? department;

  Employee({
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
    this.user,
    this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
      position: json['position'] as String? ?? '',
      employeeType: EmployeeType.fromString(json['employeeType'] as String?),
      joinDate: DateTime.tryParse(json['joinDate'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: EmployeeStatus.fromString(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      user: json['user'] != null
          ? EmployeeUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      department: json['department'] != null
          ? EmployeeDepartment.fromJson(
              json['department'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'employeeId': employeeId,
      'departmentId': departmentId,
      'position': position,
      'employeeType': employeeType.toRawString(),
      'joinDate': joinDate.toIso8601String(),
      'status': status.toRawString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (user != null) 'user': user!.toJson(),
      if (department != null) 'department': department!.toJson(),
    };
  }

  Employee copyWith({
    String? id,
    String? userId,
    String? employeeId,
    String? departmentId,
    String? position,
    EmployeeType? employeeType,
    DateTime? joinDate,
    EmployeeStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    EmployeeUser? user,
    EmployeeDepartment? department,
  }) {
    return Employee(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      departmentId: departmentId ?? this.departmentId,
      position: position ?? this.position,
      employeeType: employeeType ?? this.employeeType,
      joinDate: joinDate ?? this.joinDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      department: department ?? this.department,
    );
  }
}

class EmployeeUser {
  final String id;
  final String email;
  final String firstName;

  EmployeeUser({
    required this.id,
    required this.email,
    required this.firstName,
  });

  factory EmployeeUser.fromJson(Map<String, dynamic> json) {
    return EmployeeUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
    };
  }
}

class EmployeeDepartment {
  final String id;
  final String name;
  final String? description;

  EmployeeDepartment({
    required this.id,
    required this.name,
    this.description,
  });

  factory EmployeeDepartment.fromJson(Map<String, dynamic> json) {
    return EmployeeDepartment(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
    };
  }
}