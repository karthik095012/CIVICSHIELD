import 'package:uuid/uuid.dart';

class ComplaintSummary {
  final String id;
  final String incidentReportId;
  final String title;
  final String description;
  final String issueType;
  final String violationCategory;
  final double amountInvolved;
  final String location;
  final DateTime incidentDate;
  final String authorityInvolved;
  final List<String> evidence;
  final String severity;
  final String status;
  final List<String> recommendedActions;
  final DateTime createdAt;
  final DateTime? exportedAt;

  ComplaintSummary({
    String? id,
    required this.incidentReportId,
    required this.title,
    required this.description,
    required this.issueType,
    required this.violationCategory,
    required this.amountInvolved,
    required this.location,
    required this.incidentDate,
    required this.authorityInvolved,
    required this.evidence,
    required this.severity,
    required this.status,
    required this.recommendedActions,
    DateTime? createdAt,
    this.exportedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  String toFormattedText() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('COMPLAINT SUMMARY');
    buffer.writeln('=' * 50);
    buffer.writeln('Generated: ${DateTime.now().toString()}');
    buffer.writeln('');
    buffer.writeln('INCIDENT DETAILS');
    buffer.writeln('Title: $title');
    buffer.writeln('Type: $issueType');
    buffer.writeln('Violation: $violationCategory');
    buffer.writeln('Date: ${incidentDate.toString()}');
    buffer.writeln('Location: $location');
    buffer.writeln('Amount Involved: ₹$amountInvolved');
    buffer.writeln('Authority: $authorityInvolved');
    buffer.writeln('');
    buffer.writeln('DESCRIPTION');
    buffer.writeln(description);
    buffer.writeln('');
    buffer.writeln('SEVERITY LEVEL');
    buffer.writeln(severity.toUpperCase());
    buffer.writeln('');
    buffer.writeln('STATUS');
    buffer.writeln(status);
    buffer.writeln('');
    if (evidence.isNotEmpty) {
      buffer.writeln('EVIDENCE');
      for (int i = 0; i < evidence.length; i++) {
        buffer.writeln('${i + 1}. ${evidence[i]}');
      }
      buffer.writeln('');
    }
    buffer.writeln('RECOMMENDED ACTIONS');
    for (int i = 0; i < recommendedActions.length; i++) {
      buffer.writeln('${i + 1}. ${recommendedActions[i]}');
    }
    buffer.writeln('');
    buffer.writeln('=' * 50);
    buffer.writeln('This is an auto-generated summary from CivicShield');
    buffer.writeln('For official use and complaint submission');
    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidentReportId': incidentReportId,
      'title': title,
      'description': description,
      'issueType': issueType,
      'violationCategory': violationCategory,
      'amountInvolved': amountInvolved,
      'location': location,
      'incidentDate': incidentDate.toIso8601String(),
      'authorityInvolved': authorityInvolved,
      'evidence': evidence,
      'severity': severity,
      'status': status,
      'recommendedActions': recommendedActions,
      'createdAt': createdAt.toIso8601String(),
      'exportedAt': exportedAt?.toIso8601String(),
    };
  }

  factory ComplaintSummary.fromJson(Map<String, dynamic> json) {
    return ComplaintSummary(
      id: json['id'] as String,
      incidentReportId: json['incidentReportId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      issueType: json['issueType'] as String,
      violationCategory: json['violationCategory'] as String,
      amountInvolved: (json['amountInvolved'] as num).toDouble(),
      location: json['location'] as String,
      incidentDate: DateTime.parse(json['incidentDate'] as String),
      authorityInvolved: json['authorityInvolved'] as String,
      evidence: List<String>.from(json['evidence'] as List),
      severity: json['severity'] as String,
      status: json['status'] as String,
      recommendedActions: List<String>.from(json['recommendedActions'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      exportedAt: json['exportedAt'] != null ? DateTime.parse(json['exportedAt'] as String) : null,
    );
  }
}
