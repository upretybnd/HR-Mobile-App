class ApplicationsModel {
  final bool success;
  final List<ApplicationData> data;
  final String message;

  ApplicationsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ApplicationsModel.fromJson(Map<String, dynamic> json) {
    return ApplicationsModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<ApplicationData>.from(
              json['data'].map((x) => ApplicationData.fromJson(x)))
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

class ApplicationData {
  final String id;
  final String jobId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? resumeUrl;
  final String coverLetter;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ApplicationJob? job;

  ApplicationData({
    required this.id,
    required this.jobId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.resumeUrl,
    required this.coverLetter,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.job,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      resumeUrl: json['resumeUrl'],
      coverLetter: json['coverLetter'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      job: json['job'] != null ? ApplicationJob.fromJson(json['job']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'resumeUrl': resumeUrl,
      'coverLetter': coverLetter,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'job': job?.toJson(),
    };
  }
}

class ApplicationJob {
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
  final ApplicationDepartment? department;

  ApplicationJob({
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

  factory ApplicationJob.fromJson(Map<String, dynamic> json) {
    return ApplicationJob(
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
          ? ApplicationDepartment.fromJson(json['department'])
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

class ApplicationDepartment {
  final String id;
  final String name;

  ApplicationDepartment({
    required this.id,
    required this.name,
  });

  factory ApplicationDepartment.fromJson(Map<String, dynamic> json) {
    return ApplicationDepartment(
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