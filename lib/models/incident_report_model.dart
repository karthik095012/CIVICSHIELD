import 'package:uuid/uuid.dart';

enum ReportStatus { saved, submitted, exported, unresolved }

enum IssueType { overcharging, noReceipt, brideRequest, wrongFine, harassment, misleading }

class IncidentReportModel {
  final String id;
  final String issueType;
  final String violationCategory;
  final double? amountAsked;
  final double? amountPaid;
  final bool receiptGiven;
  final String locationName;
  final double? lat;
  final double? lng;
  final DateTime timestamp;
  final String notes;
  final List<String> mediaUrls;
  final String status;
  final int supportCount;
  final bool isAnonymous;
  final String? aiSummary;

  IncidentReportModel({
    String? id,
    required this.issueType,
    required this.violationCategory,
    this.amountAsked,
    this.amountPaid,
    required this.receiptGiven,
    required this.locationName,
    this.lat,
    this.lng,
    DateTime? timestamp,
    required this.notes,
    List<String>? mediaUrls,
    this.status = 'saved',
    this.supportCount = 0,
    this.isAnonymous = true,
    this.aiSummary,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now(),
        mediaUrls = mediaUrls ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issue_type': issueType,
      'violation_category': violationCategory,
      'amount_asked': amountAsked,
      'amount_paid': amountPaid,
      'receipt_given': receiptGiven,
      'location_name': locationName,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'media_urls': mediaUrls,
      'status': status,
      'support_count': supportCount,
      'is_anonymous': isAnonymous,
      'ai_summary': aiSummary,
    };
  }

  factory IncidentReportModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportModel(
      id: json['id'] as String,
      issueType: json['issue_type'] as String,
      violationCategory: json['violation_category'] as String,
      amountAsked: (json['amount_asked'] as num?)?.toDouble(),
      amountPaid: (json['amount_paid'] as num?)?.toDouble(),
      receiptGiven: json['receipt_given'] as bool,
      locationName: json['location_name'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String,
      mediaUrls: List<String>.from(json['media_urls'] as List),
      status: json['status'] as String,
      supportCount: json['support_count'] as int? ?? 0,
      isAnonymous: json['is_anonymous'] as bool? ?? true,
      aiSummary: json['ai_summary'] as String?,
    );
  }

  IncidentReportModel copyWith({String? status, String? aiSummary}) {
    return IncidentReportModel(
      id: id,
      issueType: issueType,
      violationCategory: violationCategory,
      amountAsked: amountAsked,
      amountPaid: amountPaid,
      receiptGiven: receiptGiven,
      locationName: locationName,
      lat: lat,
      lng: lng,
      timestamp: timestamp,
      notes: notes,
      mediaUrls: mediaUrls,
      status: status ?? this.status,
      supportCount: supportCount,
      isAnonymous: isAnonymous,
      aiSummary: aiSummary ?? this.aiSummary,
    );
  }

  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year}';
  }

  String get issueTypeDisplay {
    switch (issueType) {
      case 'overcharging':
        return 'Overcharging';
      case 'no_receipt':
        return 'No Receipt Issued';
      case 'bribe_request':
        return 'Bribe Request';
      case 'wrong_fine':
        return 'Wrong Fine Applied';
      case 'harassment':
        return 'Harassment / Intimidation';
      case 'misleading':
        return 'Misleading Information';
      default:
        return issueType;
    }
  }
}
