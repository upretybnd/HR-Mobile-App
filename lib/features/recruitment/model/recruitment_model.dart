class RecruitmentModel {
  final bool success;
  final List<JobData> data;
  final String message;

  RecruitmentModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RecruitmentModel.fromJson(Map<String, dynamic> json) {
    return RecruitmentModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<JobData>.from(json['data'].map((x) => JobData.fromJson(x)))
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

class JobData {
  final String id;
  final String companyId;
  final String departmentId;
  final String title;
  final String description;
  final String type;
  final String location;
  final String status;
  final DateTime? deadline;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RecruitmentDepartment? department;

  JobData({
    required this.id,
    required this.companyId,
    required this.departmentId,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.status,
    this.deadline,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.department,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['id'] ?? '',
      companyId: json['companyId'] ?? '',
      departmentId: json['departmentId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      department: json['department'] != null
          ? RecruitmentDepartment.fromJson(json['department'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'departmentId': departmentId,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'department': department?.toJson(),
    };
  }
}

class RecruitmentDepartment {
  final String id;
  final String name;

  RecruitmentDepartment({
    required this.id,
    required this.name,
  });

  factory RecruitmentDepartment.fromJson(Map<String, dynamic> json) {
    return RecruitmentDepartment(
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