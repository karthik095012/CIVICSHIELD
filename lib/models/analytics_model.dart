class IncidentStats {
  final int totalReports;
  final int resolvedReports;
  final int pendingReports;
  final double totalAmountInvolved;
  final int highSeverityCount;
  final int mediumSeverityCount;
  final int lowSeverityCount;
  final Map<String, int> issueTypeBreakdown;
  final Map<String, int> categoryBreakdown;
  final DateTime lastUpdated;

  IncidentStats({
    required this.totalReports,
    required this.resolvedReports,
    required this.pendingReports,
    required this.totalAmountInvolved,
    required this.highSeverityCount,
    required this.mediumSeverityCount,
    required this.lowSeverityCount,
    required this.issueTypeBreakdown,
    required this.categoryBreakdown,
    required this.lastUpdated,
  });

  double get resolutionRate =>
      totalReports > 0 ? (resolvedReports / totalReports * 100) : 0.0;

  factory IncidentStats.empty() {
    return IncidentStats(
      totalReports: 0,
      resolvedReports: 0,
      pendingReports: 0,
      totalAmountInvolved: 0,
      highSeverityCount: 0,
      mediumSeverityCount: 0,
      lowSeverityCount: 0,
      issueTypeBreakdown: {},
      categoryBreakdown: {},
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReports': totalReports,
      'resolvedReports': resolvedReports,
      'pendingReports': pendingReports,
      'totalAmountInvolved': totalAmountInvolved,
      'highSeverityCount': highSeverityCount,
      'mediumSeverityCount': mediumSeverityCount,
      'lowSeverityCount': lowSeverityCount,
      'issueTypeBreakdown': issueTypeBreakdown,
      'categoryBreakdown': categoryBreakdown,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory IncidentStats.fromJson(Map<String, dynamic> json) {
    return IncidentStats(
      totalReports: json['totalReports'] as int,
      resolvedReports: json['resolvedReports'] as int,
      pendingReports: json['pendingReports'] as int,
      totalAmountInvolved: (json['totalAmountInvolved'] as num).toDouble(),
      highSeverityCount: json['highSeverityCount'] as int,
      mediumSeverityCount: json['mediumSeverityCount'] as int,
      lowSeverityCount: json['lowSeverityCount'] as int,
      issueTypeBreakdown: Map<String, int>.from(
        json['issueTypeBreakdown'] as Map,
      ),
      categoryBreakdown: Map<String, int>.from(
        json['categoryBreakdown'] as Map,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

class CommunityStats {
  final int totalContributions;
  final int supportCount;
  final int hotspotCount;
  final List<HotspotData> topHotspots;
  final List<IssueData> mostReportedIssues;
  final DateTime lastUpdated;

  CommunityStats({
    required this.totalContributions,
    required this.supportCount,
    required this.hotspotCount,
    required this.topHotspots,
    required this.mostReportedIssues,
    required this.lastUpdated,
  });

  factory CommunityStats.empty() {
    return CommunityStats(
      totalContributions: 0,
      supportCount: 0,
      hotspotCount: 0,
      topHotspots: [],
      mostReportedIssues: [],
      lastUpdated: DateTime.now(),
    );
  }
}

class HotspotData {
  final String name;
  final int reportCount;
  final String severity;
  final double latitude;
  final double longitude;

  HotspotData({
    required this.name,
    required this.reportCount,
    required this.severity,
    required this.latitude,
    required this.longitude,
  });
}

class IssueData {
  final String name;
  final int count;
  final String category;

  IssueData({
    required this.name,
    required this.count,
    required this.category,
  });
}
