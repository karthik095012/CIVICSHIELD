import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../widgets/custom_cards.dart';
import '../../widgets/custom_widgets.dart';
import '../../providers/analytics_provider.dart';

class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends ConsumerState<AnalyticsDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final incidentStats = ref.watch(incidentStatsProvider);
    final communityStats = ref.watch(communityStatsProvider);
    final monthlyTrend = ref.watch(monthlyTrendProvider);

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: CivicShieldTheme.surfaceDark,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: CivicShieldTheme.premiumGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Analytics & Insights',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: CivicShieldTheme.textPrimary,
                          ),
                        ),
                        const Text(
                          'Your reports and community impact',
                          style: TextStyle(
                            fontSize: 12,
                            color: CivicShieldTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: incidentStats.when(
                data: (stats) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Your Reports', subtitle: 'Personal incident tracking'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        StatCard(
                          label: 'Total Reports',
                          value: stats.totalReports.toString(),
                          icon: Icons.assessment_rounded,
                          valueColor: CivicShieldTheme.accentCyan,
                        ),
                        StatCard(
                          label: 'Resolved',
                          value: stats.resolvedReports.toString(),
                          icon: Icons.check_circle_rounded,
                          valueColor: CivicShieldTheme.successGreen,
                        ),
                        StatCard(
                          label: 'Pending',
                          value: stats.pendingReports.toString(),
                          icon: Icons.schedule_rounded,
                          valueColor: CivicShieldTheme.warningOrange,
                        ),
                        StatCard(
                          label: 'Amount Reported',
                          value: '₹${stats.totalAmountInvolved.toStringAsFixed(0)}',
                          icon: Icons.currency_rupee_rounded,
                          valueColor: CivicShieldTheme.infoBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'Resolution Rate', subtitle: '${stats.resolutionRate.toStringAsFixed(1)}%'),
                    const SizedBox(height: 12),
                    ProgressIndicatorCustom(
                      value: stats.resolutionRate / 100,
                      label: 'Reports Resolved',
                      color: CivicShieldTheme.successGreen,
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'Severity Breakdown', subtitle: 'Incident severity distribution'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSeverityBox(
                            'High Severity',
                            stats.highSeverityCount.toString(),
                            CivicShieldTheme.highSeverity,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSeverityBox(
                            'Medium Severity',
                            stats.mediumSeverityCount.toString(),
                            CivicShieldTheme.medSeverity,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSeverityBox(
                            'Low Severity',
                            stats.lowSeverityCount.toString(),
                            CivicShieldTheme.lowSeverity,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'Most Reported Issues', subtitle: 'Top 6 categories'),
                    const SizedBox(height: 12),
                    ..._buildIssueBreakdown(stats.issueTypeBreakdown),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: communityStats.when(
                data: (stats) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Community Impact',
                      subtitle: 'Your contribution to civic engagement',
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        StatCard(
                          label: 'Contributions',
                          value: stats.totalContributions.toString(),
                          icon: Icons.volunteer_activism_rounded,
                          valueColor: CivicShieldTheme.accentCyan,
                        ),
                        StatCard(
                          label: 'Community Support',
                          value: stats.supportCount.toString(),
                          icon: Icons.people_rounded,
                          valueColor: CivicShieldTheme.successGreen,
                        ),
                        StatCard(
                          label: 'Hotspots',
                          value: stats.hotspotCount.toString(),
                          icon: Icons.location_on_rounded,
                          valueColor: CivicShieldTheme.warningOrange,
                        ),
                        StatCard(
                          label: 'Avg Impact Score',
                          value: '${(stats.totalContributions * 0.8).toStringAsFixed(0)}',
                          icon: Icons.trending_up_rounded,
                          valueColor: CivicShieldTheme.infoBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'Top Hotspots', subtitle: 'Most reported areas'),
                    const SizedBox(height: 12),
                    ...stats.topHotspots.map((hotspot) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getSeverityColor(hotspot.severity).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: _getSeverityColor(hotspot.severity),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotspot.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: CivicShieldTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${hotspot.reportCount} reports',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: CivicShieldTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SeverityBadge(
                              label: hotspot.severity,
                              color: _getSeverityColor(hotspot.severity),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              child: monthlyTrend.when(
                data: (trend) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Monthly Trend', subtitle: 'Your reporting activity'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: trend.map((data) {
                                  final maxValue = trend.map((e) => e.count).reduce((a, b) => a > b ? a : b);
                                  final height = (data.count / maxValue) * 150;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        data.count.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: CivicShieldTheme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 24,
                                        height: height.toDouble(),
                                        decoration: BoxDecoration(
                                          gradient: CivicShieldTheme.vibrantSaffronGradient,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        data.month,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: CivicShieldTheme.textMuted,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBox(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: CivicShieldTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIssueBreakdown(Map<String, int> breakdown) {
    final sortedIssues = breakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sortedIssues
        .take(6)
        .map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatIssueName(entry.key),
                        style: const TextStyle(fontSize: 13, color: CivicShieldTheme.textSecondary),
                      ),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: CivicShieldTheme.accentCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ProgressIndicatorCustom(
                    value: entry.value / 15,
                    label: '',
                  ),
                ],
              ),
            ))
        .toList();
  }

  String _formatIssueName(String name) {
    return name.replaceAll('_', ' ').split(' ').map((word) => '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return CivicShieldTheme.highSeverity;
      case 'medium':
        return CivicShieldTheme.medSeverity;
      case 'low':
        return CivicShieldTheme.lowSeverity;
      default:
        return CivicShieldTheme.infoBlue;
    }
  }
}
