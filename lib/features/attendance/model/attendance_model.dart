// attendance_model.dart
// Dart/Flutter models for the Attendance API response.

class AttendanceModel {
  final bool success;
  final List<AttendanceRecord> data;
  final String message;

  const AttendanceModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
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

  AttendanceModel copyWith({
    bool? success,
    List<AttendanceRecord>? data,
    String? message,
  }) {
    return AttendanceModel(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'AttendanceModel(success: $success, data: $data, message: $message)';
}

class AttendanceRecord {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final DateTime? breakIn;
  final DateTime? breakOut;
  final int overtimeMinutes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Employee employee;
  final List<String> flags;

  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.breakIn,
    this.breakOut,
    required this.overtimeMinutes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
    required this.flags,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      checkIn: json['checkIn'] != null
          ? DateTime.parse(json['checkIn'] as String)
          : null,
      checkOut: json['checkOut'] != null
          ? DateTime.parse(json['checkOut'] as String)
          : null,
      breakIn: json['breakIn'] != null
          ? DateTime.parse(json['breakIn'] as String)
          : null,
      breakOut: json['breakOut'] != null
          ? DateTime.parse(json['breakOut'] as String)
          : null,
      overtimeMinutes: json['overtimeMinutes'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      employee: Employee.fromJson(json['employee'] as Map<String, dynamic>),
      flags: (json['flags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'date': date.toIso8601String(),
      'checkIn': checkIn?.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'breakIn': breakIn?.toIso8601String(),
      'breakOut': breakOut?.toIso8601String(),
      'overtimeMinutes': overtimeMinutes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'employee': employee.toJson(),
      'flags': flags,
    };
  }

  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    DateTime? breakIn,
    DateTime? breakOut,
    int? overtimeMinutes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Employee? employee,
    List<String>? flags,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      breakIn: breakIn ?? this.breakIn,
      breakOut: breakOut ?? this.breakOut,
      overtimeMinutes: overtimeMinutes ?? this.overtimeMinutes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      employee: employee ?? this.employee,
      flags: flags ?? this.flags,
    );
  }

  @override
  String toString() =>
      'AttendanceRecord(id: $id, employeeId: $employeeId, status: $status)';
}

class Employee {
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
  final EmployeeUser user;
  final Department department;

  const Employee({
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

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
      position: json['position'] as String? ?? '',
      employeeType: json['employeeType'] as String? ?? '',
      joinDate: DateTime.parse(json['joinDate'] as String),
      status: json['status'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: EmployeeUser.fromJson(json['user'] as Map<String, dynamic>),
      department:
          Department.fromJson(json['department'] as Map<String, dynamic>),
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

  Employee copyWith({
    String? id,
    String? userId,
    String? employeeId,
    String? departmentId,
    String? position,
    String? employeeType,
    DateTime? joinDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    EmployeeUser? user,
    Department? department,
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

  @override
  String toString() => 'Employee(id: $id, position: $position)';
}

class EmployeeUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;

  const EmployeeUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
  });

  String get fullName => '$firstName $lastName';

  factory EmployeeUser.fromJson(Map<String, dynamic> json) {
    return EmployeeUser(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
    };
  }

  EmployeeUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
  }) {
    return EmployeeUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() => 'EmployeeUser(id: $id, fullName: $fullName)';
}

class Department {
  final String id;
  final String name;

  const Department({
    required this.id,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Department copyWith({
    String? id,
    String? name,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'Department(id: $id, name: $name)';
}