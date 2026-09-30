class FilesModel {
  final bool success;
  final List<FileData> data;
  final String message;

  FilesModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FilesModel.fromJson(Map<String, dynamic> json) {
    return FilesModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<FileData>.from(
              json['data'].map((x) => FileData.fromJson(x)))
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

class FileData {
  final String id;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final DateTime createdAt;
  final String downloadUrl;

  FileData({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.createdAt,
    required this.downloadUrl,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      mimeType: json['mimeType'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      downloadUrl: json['downloadUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'createdAt': createdAt.toIso8601String(),
      'downloadUrl': downloadUrl,
    };
  }
}