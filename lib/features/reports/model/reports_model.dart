class ReportsModel {
  final bool success;
  final List<ReportData> data;
  final String message;

  ReportsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) {
    return ReportsModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<ReportData>.from(
              json['data'].map((x) => ReportData.fromJson(x)))
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

class ReportData {
  final String id;
  final String companyId;
  final String createdById;
  final String type;
  final String format;
  final String? fileUrl;
  final String status;
  final String? data;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CreatedBy? createdBy;

  ReportData({
    required this.id,
    required this.companyId,
    required this.createdById,
    required this.type,
    required this.format,
    this.fileUrl,
    required this.status,
    this.data,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      id: json['id'] ?? '',
      companyId: json['companyId'] ?? '',
      createdById: json['createdById'] ?? '',
      type: json['type'] ?? '',
      format: json['format'] ?? '',
      fileUrl: json['fileUrl'],
      status: json['status'] ?? '',
      data: json['data'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      createdBy: json['createdBy'] != null
          ? CreatedBy.fromJson(json['createdBy'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'createdById': createdById,
      'type': type,
      'format': format,
      'fileUrl': fileUrl,
      'status': status,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy?.toJson(),
    };
  }
}

class CreatedBy {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
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