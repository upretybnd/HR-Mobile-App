

class LeaveModel {
  final bool success;
  final List<LeaveRecord> data;
  final String message;

  const LeaveModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LeaveRecord.fromJson(e as Map<String, dynamic>))
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

  LeaveModel copyWith({
    bool? success,
    List<LeaveRecord>? data,
    String? message,
  }) {
    return LeaveModel(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'LeaveModel(success: $success, data: $data, message: $message)';
}

class LeaveRecord {
  final String id;
  final String employeeId;
  final String leaveTypeId;
  final DateTime from;
  final DateTime to;
  final String reason;
  final String status;
  final String? reviewedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LeaveEmployee employee;
  final LeaveType leaveType;
  final LeaveReviewer? reviewer;

  const LeaveRecord({
    required this.id,
    required this.employeeId,
    required this.leaveTypeId,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
    this.reviewedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
    required this.leaveType,
    this.reviewer,
  });

  factory LeaveRecord.fromJson(Map<String, dynamic> json) {
    return LeaveRecord(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      leaveTypeId: json['leaveTypeId'] as String? ?? '',
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? '',
      reviewedBy: json['reviewedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      employee:
          LeaveEmployee.fromJson(json['employee'] as Map<String, dynamic>),
      leaveType:
          LeaveType.fromJson(json['leaveType'] as Map<String, dynamic>),
      reviewer: json['reviewer'] != null
          ? LeaveReviewer.fromJson(json['reviewer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'leaveTypeId': leaveTypeId,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'reason': reason,
      'status': status,
      'reviewedBy': reviewedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'employee': employee.toJson(),
      'leaveType': leaveType.toJson(),
      'reviewer': reviewer?.toJson(),
    };
  }

  LeaveRecord copyWith({
    String? id,
    String? employeeId,
    String? leaveTypeId,
    DateTime? from,
    DateTime? to,
    String? reason,
    String? status,
    String? reviewedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    LeaveEmployee? employee,
    LeaveType? leaveType,
    LeaveReviewer? reviewer,
  }) {
    return LeaveRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      from: from ?? this.from,
      to: to ?? this.to,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      employee: employee ?? this.employee,
      leaveType: leaveType ?? this.leaveType,
      reviewer: reviewer ?? this.reviewer,
    );
  }

  @override
  String toString() =>
      'LeaveRecord(id: $id, employeeId: $employeeId, status: $status)';
}

class LeaveEmployee {
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
  final LeaveUser user;

  const LeaveEmployee({
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

  factory LeaveEmployee.fromJson(Map<String, dynamic> json) {
    return LeaveEmployee(
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
      user: LeaveUser.fromJson(json['user'] as Map<String, dynamic>),
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

  LeaveEmployee copyWith({
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
    LeaveUser? user,
  }) {
    return LeaveEmployee(
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
    );
  }

  @override
  String toString() => 'LeaveEmployee(id: $id, position: $position)';
}

class LeaveUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  const LeaveUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  factory LeaveUser.fromJson(Map<String, dynamic> json) {
    return LeaveUser(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  LeaveUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return LeaveUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'LeaveUser(id: $id, fullName: $fullName)';
}

class LeaveType {
  final String id;
  final String name;
  final int daysPerYear;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LeaveType({
    required this.id,
    required this.name,
    required this.daysPerYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      daysPerYear: json['daysPerYear'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'daysPerYear': daysPerYear,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LeaveType copyWith({
    String? id,
    String? name,
    int? daysPerYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeaveType(
      id: id ?? this.id,
      name: name ?? this.name,
      daysPerYear: daysPerYear ?? this.daysPerYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'LeaveType(id: $id, name: $name)';
}

// The sample "reviewer" is always null, so its shape is inferred as
// similar to LeaveUser (a reviewing user). Adjust fields if the actual
// API returns a different structure once populated.
class LeaveReviewer {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  const LeaveReviewer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  factory LeaveReviewer.fromJson(Map<String, dynamic> json) {
    return LeaveReviewer(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  LeaveReviewer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return LeaveReviewer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'LeaveReviewer(id: $id, fullName: $fullName)';
}