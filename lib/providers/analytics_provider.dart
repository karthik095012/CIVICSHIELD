import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics_model.dart';

final incidentStatsProvider = FutureProvider<IncidentStats>((ref) async {
  // TODO: Replace with actual data fetching logic
  await Future.delayed(const Duration(milliseconds: 300));

  return IncidentStats(
    totalReports: 42,
    resolvedReports: 28,
    pendingReports: 14,
    totalAmountInvolved: 15650,
    highSeverityCount: 6,
    mediumSeverityCount: 18,
    lowSeverityCount: 18,
    issueTypeBreakdown: {
      'overcharging': 12,
      'no_receipt': 8,
      'bribe_request': 5,
      'wrong_violation': 7,
      'harassment': 3,
      'misleading': 7,
    },
    categoryBreakdown: {
      'traffic': 25,
      'anticorruption': 8,
      'consumer': 4,
      'legal': 3,
      'rti': 2,
    },
    lastUpdated: DateTime.now(),
  );
});

final communityStatsProvider = FutureProvider<CommunityStats>((ref) async {
  // TODO: Replace with actual data fetching logic
  await Future.delayed(const Duration(milliseconds: 300));

  return CommunityStats(
    totalContributions: 156,
    supportCount: 89,
    hotspotCount: 12,
    topHotspots: [
      HotspotData(
        name: 'MG Road Signal Junction',
        reportCount: 8,
        severity: 'high',
        latitude: 12.9716,
        longitude: 77.5946,
      ),
      HotspotData(
        name: 'Bangalore Fort Gate',
        reportCount: 6,
        severity: 'medium',
        latitude: 12.9561,
        longitude: 77.5999,
      ),
      HotspotData(
        name: 'Vidhana Soudha Circle',
        reportCount: 5,
        severity: 'medium',
        latitude: 12.9676,
        longitude: 77.5773,
      ),
    ],
    mostReportedIssues: [
      IssueData(name: 'Overcharging', count: 12, category: 'traffic'),
      IssueData(name: 'No Receipt/Challan', count: 8, category: 'traffic'),
      IssueData(name: 'Bribe Request', count: 5, category: 'anticorruption'),
      IssueData(name: 'Wrong Violation Applied', count: 7, category: 'traffic'),
    ],
    lastUpdated: DateTime.now(),
  );
});

final monthlyTrendProvider = FutureProvider<List<TrendData>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));

  return [
    TrendData(month: 'Jan', count: 8),
    TrendData(month: 'Feb', count: 12),
    TrendData(month: 'Mar', count: 15),
    TrendData(month: 'Apr', count: 18),
    TrendData(month: 'May', count: 22),
    TrendData(month: 'Jun', count: 28),
  ];
});

class TrendData {
  final String month;
  final int count;

  TrendData({required this.month, required this.count});
}
