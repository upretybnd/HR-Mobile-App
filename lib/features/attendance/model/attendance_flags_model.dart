class AttendanceFlagsResponse {
  final bool success;
  final List<AttendanceFlagsModel> data;
  final String message;

  AttendanceFlagsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory AttendanceFlagsResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceFlagsResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AttendanceFlagsModel.fromJson(e as Map<String, dynamic>))
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

class AttendanceFlagsModel {
  final String id;
  final String attendanceId;
  final String createdBy;
  final String reason;
  final String? note;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final FlagCreatorModel creator;
  final FlagAttendanceModel attendance;

  AttendanceFlagsModel({
    required this.id,
    required this.attendanceId,
    required this.createdBy,
    required this.reason,
    this.note,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    required this.creator,
    required this.attendance,
  });

  factory AttendanceFlagsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceFlagsModel(
      id: json['id'] as String? ?? '',
      attendanceId: json['attendanceId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      note: json['note'] as String?,
      status: json['status'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'] as String)
          : null,
      creator: FlagCreatorModel.fromJson(
          json['creator'] as Map<String, dynamic>? ?? {}),
      attendance: FlagAttendanceModel.fromJson(
          json['attendance'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendanceId': attendanceId,
      'createdBy': createdBy,
      'reason': reason,
      'note': note,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'creator': creator.toJson(),
      'attendance': attendance.toJson(),
    };
  }
}

class FlagCreatorModel {
  final String id;
  final String firstName;
  final String lastName;

  FlagCreatorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory FlagCreatorModel.fromJson(Map<String, dynamic> json) {
    return FlagCreatorModel(
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

class FlagAttendanceModel {
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
  final FlagEmployeeModel employee;

  FlagAttendanceModel({
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
  });

  factory FlagAttendanceModel.fromJson(Map<String, dynamic> json) {
    return FlagAttendanceModel(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.now(),
      checkIn: json['checkIn'] != null
          ? DateTime.tryParse(json['checkIn'] as String)
          : null,
      checkOut: json['checkOut'] != null
          ? DateTime.tryParse(json['checkOut'] as String)
          : null,
      breakIn: json['breakIn'] != null
          ? DateTime.tryParse(json['breakIn'] as String)
          : null,
      breakOut: json['breakOut'] != null
          ? DateTime.tryParse(json['breakOut'] as String)
          : null,
      overtimeMinutes: json['overtimeMinutes'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      employee: FlagEmployeeModel.fromJson(
          json['employee'] as Map<String, dynamic>? ?? {}),
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
    };
  }
}

class FlagEmployeeModel {
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
  final FlagEmployeeUserModel user;

  FlagEmployeeModel({
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

  factory FlagEmployeeModel.fromJson(Map<String, dynamic> json) {
    return FlagEmployeeModel(
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
      user: FlagEmployeeUserModel.fromJson(
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

class FlagEmployeeUserModel {
  final String id;
  final String firstName;
  final String lastName;

  FlagEmployeeUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory FlagEmployeeUserModel.fromJson(Map<String, dynamic> json) {
    return FlagEmployeeUserModel(
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