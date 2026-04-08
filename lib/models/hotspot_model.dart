class HotspotModel {
  final String id;
  final String areaName;
  final double lat;
  final double lng;
  final String issueCategory;
  final int reportCount;
  final String severityLevel;
  final String lastReportedAt;
  final String status;
  final int daysUnresolved;
  final String description;
  int supportCount;

  HotspotModel({
    required this.id,
    required this.areaName,
    required this.lat,
    required this.lng,
    required this.issueCategory,
    required this.reportCount,
    required this.severityLevel,
    required this.lastReportedAt,
    required this.status,
    required this.daysUnresolved,
    required this.description,
    this.supportCount = 0,
  });

  factory HotspotModel.fromJson(Map<String, dynamic> json) {
    return HotspotModel(
      id: json['id'] as String,
      areaName: json['area_name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      issueCategory: json['issue_category'] as String,
      reportCount: json['report_count'] as int,
      severityLevel: json['severity_level'] as String,
      lastReportedAt: json['last_reported_at'] as String,
      status: json['status'] as String,
      daysUnresolved: json['days_unresolved'] as int,
      description: json['description'] as String,
      supportCount: 0,
    );
  }

  HotspotModel copyWith({int? supportCount}) {
    return HotspotModel(
      id: id,
      areaName: areaName,
      lat: lat,
      lng: lng,
      issueCategory: issueCategory,
      reportCount: reportCount,
      severityLevel: severityLevel,
      lastReportedAt: lastReportedAt,
      status: status,
      daysUnresolved: daysUnresolved,
      description: description,
      supportCount: supportCount ?? this.supportCount,
    );
  }
}
