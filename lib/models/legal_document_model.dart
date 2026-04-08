// Legal Document Model for Evidence Vault
class LegalDocument {
  final String id;
  final String fileName;
  final String fileType; // 'pdf', 'ppt', 'audio', 'video', 'image', 'text', 'doc', 'excel'
  final String? clientName;
  final String? caseNumber;
  final String? description;
  final DateTime uploadedAt;
  final int fileSizeBytes;
  final String? filePath; // Local path or cloud URL
  final String status; // 'saved', 'processing', 'verified'
  final List<String> tags; // For categorization
  final DateTime? expiryDate;
  final bool isEncrypted;

  LegalDocument({
    required this.id,
    required this.fileName,
    required this.fileType,
    this.clientName,
    this.caseNumber,
    this.description,
    required this.uploadedAt,
    required this.fileSizeBytes,
    this.filePath,
    this.status = 'saved',
    this.tags = const [],
    this.expiryDate,
    this.isEncrypted = true,
  });

  // Get display name for file type
  String getFileTypeLabel() {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return 'PDF Document';
      case 'ppt':
      case 'pptx':
        return 'Presentation';
      case 'audio':
      case 'mp3':
      case 'wav':
      case 'm4a':
        return 'Audio';
      case 'video':
      case 'mp4':
      case 'mov':
      case 'avi':
        return 'Video';
      case 'image':
      case 'jpg':
      case 'png':
      case 'jpeg':
        return 'Image';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'xls':
      case 'xlsx':
        return 'Spreadsheet';
      case 'txt':
        return 'Text File';
      default:
        return 'File';
    }
  }

  // Get icon for file type
  String getFileTypeIcon() {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return '📄';
      case 'ppt':
      case 'pptx':
        return '🎯';
      case 'audio':
      case 'mp3':
      case 'wav':
      case 'm4a':
        return '🔊';
      case 'video':
      case 'mp4':
      case 'mov':
      case 'avi':
        return '🎥';
      case 'image':
      case 'jpg':
      case 'png':
      case 'jpeg':
        return '🖼️';
      case 'doc':
      case 'docx':
        return '📋';
      case 'xls':
      case 'xlsx':
        return '📊';
      case 'txt':
        return '📝';
      default:
        return '📎';
    }
  }

  // Format file size for display
  String getFormattedSize() {
    if (fileSizeBytes < 1024) {
      return '${fileSizeBytes}B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    } else if (fileSizeBytes < 1024 * 1024 * 1024) {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  // Get status badge color
  String getStatusColor() {
    switch (status) {
      case 'saved':
        return '✅';
      case 'processing':
        return '⏳';
      case 'verified':
        return '✔️';
      default:
        return '➖';
    }
  }

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      clientName: json['clientName'] as String?,
      caseNumber: json['caseNumber'] as String?,
      description: json['description'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      fileSizeBytes: json['fileSizeBytes'] as int,
      filePath: json['filePath'] as String?,
      status: json['status'] as String? ?? 'saved',
      tags: List<String>.from(json['tags'] as List? ?? []),
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate'] as String) : null,
      isEncrypted: json['isEncrypted'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'clientName': clientName,
      'caseNumber': caseNumber,
      'description': description,
      'uploadedAt': uploadedAt.toIso8601String(),
      'fileSizeBytes': fileSizeBytes,
      'filePath': filePath,
      'status': status,
      'tags': tags,
      'expiryDate': expiryDate?.toIso8601String(),
      'isEncrypted': isEncrypted,
    };
  }

  LegalDocument copyWith({
    String? id,
    String? fileName,
    String? fileType,
    String? clientName,
    String? caseNumber,
    String? description,
    DateTime? uploadedAt,
    int? fileSizeBytes,
    String? filePath,
    String? status,
    List<String>? tags,
    DateTime? expiryDate,
    bool? isEncrypted,
  }) {
    return LegalDocument(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      clientName: clientName ?? this.clientName,
      caseNumber: caseNumber ?? this.caseNumber,
      description: description ?? this.description,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      expiryDate: expiryDate ?? this.expiryDate,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }
}
