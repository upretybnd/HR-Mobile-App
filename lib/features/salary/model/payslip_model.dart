class PayslipModel {
  final bool success;
  final List<PayslipData> data;
  final String message;

  PayslipModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<PayslipData>.from(
              json['data'].map((x) => PayslipData.fromJson(x)))
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

class PayslipData {
  final String id;
  final String employeeId;
  final int month;
  final int year;
  final num baseSalary;
  final num allowances;
  final num deductions;
  final num netSalary;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Employee? employee;

  PayslipData({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.allowances,
    required this.deductions,
    required this.netSalary,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.employee,
  });

  factory PayslipData.fromJson(Map<String, dynamic> json) {
    return PayslipData(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      baseSalary: json['baseSalary'] ?? 0,
      allowances: json['allowances'] ?? 0,
      deductions: json['deductions'] ?? 0,
      netSalary: json['netSalary'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'month': month,
      'year': year,
      'baseSalary': baseSalary,
      'allowances': allowances,
      'deductions': deductions,
      'netSalary': netSalary,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'employee': employee?.toJson(),
    };
  }
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
  final User? user;
  final Department? department;

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
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      employeeId: json['employeeId'] ?? '',
      departmentId: json['departmentId'] ?? '',
      position: json['position'] ?? '',
      employeeType: json['employeeType'] ?? '',
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
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
      'employeeType': employeeType,
      'joinDate': joinDate.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'department': department?.toJson(),
    };
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
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
}

class Department {
  final String id;
  final String name;

  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}