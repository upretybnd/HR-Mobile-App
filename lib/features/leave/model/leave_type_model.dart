class LeaveTypeResponse {
  final bool success;
  final List<LeaveTypeModel> data;
  final String message;

  LeaveTypeResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory LeaveTypeResponse.fromJson(Map<String, dynamic> json) {
    return LeaveTypeResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => LeaveTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
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

class LeaveTypeModel {
  final String id;
  final String name;
  final int daysPerYear;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveTypeModel({
    required this.id,
    required this.name,
    required this.daysPerYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      daysPerYear: json['daysPerYear'] as int,
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
}