import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/report_provider.dart';
import '../../models/incident_report_model.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final currentLanguage = ref.watch(languageProvider);
    final authState = ref.watch(authProvider);
    final reports = ref.watch(reportProvider);
    final firstName = _extractFirstName(authState.user?.name ?? 'Citizen');
    final timeGreeting = _timeBasedGreeting();
    final bgColor = isDarkMode ? CivicShieldTheme.darkBg : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textSecondaryColor = isDarkMode ? CivicShieldTheme.darkTextSecondary : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, bgColor, textColor, isDarkMode, currentLanguage, timeGreeting, firstName),
          SliverToBoxAdapter(child: _buildBody(context, isDarkMode, textColor, textSecondaryColor, currentLanguage, firstName, reports)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Color bgColor, Color textColor, bool isDarkMode, String currentLanguage, String timeGreeting, String firstName) {
    return SliverAppBar(
      expandedHeight: 190,
      floating: false,
      pinned: true,
      backgroundColor: bgColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: CivicShieldTheme.premiumGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CivicShieldTheme.accentCyan.withOpacity(0.15),
                              border: Border.all(color: CivicShieldTheme.accentCyan, width: 1.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset('assets/images/app_logo.png', fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'CivicShield',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => context.go('/settings'),
                        icon: const Icon(Icons.settings_rounded, color: Colors.black, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$timeGreeting, $firstName.',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hello $firstName.\nKnow your rights. Act with confidence.',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isDarkMode, Color textColor, Color textSecondaryColor, String currentLanguage, String firstName, List<IncidentReportModel> reports) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildHelloUserCard(context, firstName),
          const SizedBox(height: 16),
          _buildEscalationBanner(context, currentLanguage, reports),
          const SizedBox(height: 20),
          _buildQuickTipCard(currentLanguage),
          const SizedBox(height: 24),
          _buildSectionTitle(LanguageNotifier.translate('quick_actions', currentLanguage)),
          const SizedBox(height: 12),
          _buildMainActionGrid(context, currentLanguage),
          const SizedBox(height: 24),
          _buildSectionTitle(LanguageNotifier.translate('more_tools', currentLanguage)),
          const SizedBox(height: 12),
          _buildSecondaryActions(context, currentLanguage),
          const SizedBox(height: 24),
          _buildDisclaimerCard(),
        ],
      ),
    );
  }

  Widget _buildHelloUserCard(BuildContext context, String firstName) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF90CAF9).withOpacity(0.6), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.waving_hand_rounded, size: 18, color: Color(0xFF1565C0)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hello $firstName, what would you like to do now?',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CivicShieldTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _QuickPill(
                icon: Icons.gavel_rounded,
                label: 'Check Fine',
                route: '/fines',
                color: Color(0xFF1E88E5),
              ),
              _QuickPill(
                icon: Icons.report_rounded,
                label: 'Report Issue',
                route: '/report',
                color: Color(0xFFE53935),
              ),
              _QuickPill(
                icon: Icons.smart_toy_rounded,
                label: 'Free AI Legal Help',
                route: '/ai-legal',
                color: Color(0xFF7B1FA2),
              ),
              _QuickPill(
                icon: Icons.newspaper_rounded,
                label: 'Law Updates',
                route: '/news',
                color: Color(0xFF2E7D32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _extractFirstName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      return 'Citizen';
    }
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  Widget _buildEscalationBanner(BuildContext context, String currentLanguage, List<IncidentReportModel> reports) {
    final escalations = _reportsNeedingEscalation(reports);
    final escalationCount = escalations.length;
    final hasPendingEscalation = escalationCount > 0;
    final oldestPendingDays = _oldestPendingDays(escalations);

    final heading = escalationCount <= 0
        ? 'No complaints need escalation'
        : escalationCount == 1
            ? LanguageNotifier.translate('complaint_notice', currentLanguage)
            : '$escalationCount complaints need attention';

    final subtitle = escalationCount <= 0
        ? 'All recorded complaints are within the follow-up window.'
        : '$oldestPendingDays days without resolution - escalate now';

    final actionLabel = hasPendingEscalation
        ? LanguageNotifier.translate('escalate_btn', currentLanguage)
        : 'View Reports';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE74C3C).withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF5E35B1))),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFFD32F2F))),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _handleEscalationTap(context, hasPendingEscalation),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasPendingEscalation ? const Color(0xFFF44336) : const Color(0xFF607D8B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<IncidentReportModel> _reportsNeedingEscalation(List<IncidentReportModel> reports) {
    final now = DateTime.now();
    return reports.where((report) {
      final ageInDays = now.difference(report.timestamp).inDays;
      final unresolved = report.status.toLowerCase() != 'submitted';
      return unresolved && ageInDays >= 7;
    }).toList();
  }

  int _oldestPendingDays(List<IncidentReportModel> reports) {
    if (reports.isEmpty) {
      return 0;
    }

    final now = DateTime.now();
    var maxDays = 0;
    for (final report in reports) {
      final days = now.difference(report.timestamp).inDays;
      if (days > maxDays) {
        maxDays = days;
      }
    }
    return maxDays;
  }

  void _handleEscalationTap(BuildContext context, bool hasPendingEscalation) {
    if (hasPendingEscalation) {
      context.go('/authorities');
      return;
    }

    context.go('/vault');
  }

  Widget _buildQuickTipCard(String currentLanguage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00897B), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00897B).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00897B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lightbulb_rounded, color: Color(0xFF00897B), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageNotifier.translate('quick_tip', currentLanguage),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF00695C), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  LanguageNotifier.translate('challan_tip', currentLanguage),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF004D40), fontWeight: FontWeight.w500, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildMainActionGrid(BuildContext context, String currentLanguage) {
    final actions = [
      _ActionItem(
        icon: Icons.gavel_rounded,
        label: LanguageNotifier.translate('fine_checker', currentLanguage),
        subtitle: LanguageNotifier.translate('fine_checker_sub', currentLanguage),
        color: const Color(0xFF1E88E5),
        gradient: const LinearGradient(colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)]),
        route: '/fines',
      ),
      _ActionItem(
        icon: Icons.shield_rounded,
        label: LanguageNotifier.translate('know_rights', currentLanguage),
        subtitle: LanguageNotifier.translate('know_rights_sub', currentLanguage),
        color: const Color(0xFF43A047),
        gradient: const LinearGradient(colors: [Color(0xFFF1F8E9), Color(0xFFC8E6C9)]),
        route: '/rights',
      ),
      _ActionItem(
        icon: Icons.report_rounded,
        label: LanguageNotifier.translate('report_misuse', currentLanguage),
        subtitle: LanguageNotifier.translate('report_misuse_sub', currentLanguage),
        color: const Color(0xFFE53935),
        gradient: const LinearGradient(colors: [Color(0xFFFFEBEE), Color(0xFFEF9A9A)]),
        route: '/report',
      ),
      _ActionItem(
        icon: Icons.location_on_rounded,
        label: LanguageNotifier.translate('community_map', currentLanguage),
        subtitle: LanguageNotifier.translate('community_map_sub', currentLanguage),
        color: const Color(0xFFFB8C00),
        gradient: const LinearGradient(colors: [Color(0xFFFFF3E0), Color(0xFFFFCC80)]),
        route: '/hotspot',
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: actions.map((a) => _HomeActionCard(item: a)).toList(),
    );
  }

  Widget _buildSecondaryActions(BuildContext context, String currentLanguage) {
    return Column(
      children: [
        _SecondaryActionTile(
          icon: Icons.lock_rounded,
          label: LanguageNotifier.translate('evidence', currentLanguage),
          subtitle: LanguageNotifier.translate('evidence_sub', currentLanguage),
          color: const Color(0xFF9C27B0),
          bgColor: const Color(0xFFF3E5F5),
          route: '/vault',
        ),
        const SizedBox(height: 10),
        _SecondaryActionTile(
          icon: Icons.account_balance_rounded,
          label: LanguageNotifier.translate('schemes', currentLanguage),
          subtitle: LanguageNotifier.translate('schemes_sub', currentLanguage),
          color: const Color(0xFF00897B),
          bgColor: const Color(0xFFE0F2F1),
          route: '/schemes',
        ),
        const SizedBox(height: 10),
        _SecondaryActionTile(
          icon: Icons.gavel_rounded,
          label: LanguageNotifier.translate('legal', currentLanguage),
          subtitle: LanguageNotifier.translate('legal_sub', currentLanguage),
          color: const Color(0xFF1565C0),
          bgColor: const Color(0xFFE3F2FD),
          route: '/legal',
        ),
        const SizedBox(height: 10),
        _SecondaryActionTile(
          icon: Icons.smart_toy_rounded,
          label: LanguageNotifier.translate('ai_legal', currentLanguage),
          subtitle: LanguageNotifier.translate('ai_legal_sub', currentLanguage),
          color: const Color(0xFF7B1FA2),
          bgColor: const Color(0xFFF3E5F5),
          route: '/ai-legal',
        ),
        const SizedBox(height: 10),
        _SecondaryActionTile(
          icon: Icons.newspaper_rounded,
          label: 'Bills & Law Updates',
          subtitle: 'Daily legal and policy headlines',
          color: const Color(0xFF2E7D32),
          bgColor: const Color(0xFFE8F5E9),
          route: '/news',
        ),
      ],
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFBC02D).withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFBC02D).withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFF57F17)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Fine amounts are indicative based on the Motor Vehicles Act 2019. Always verify with the official challan. This app is for awareness only, not a substitute for legal advice.',
              style: const TextStyle(fontSize: 11, color: Color(0xFF6F4E37), height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final LinearGradient gradient;
  final String route;
  const _ActionItem({
    required this.icon, required this.label, required this.subtitle,
    required this.color, required this.gradient, required this.route,
  });
}

class _HomeActionCard extends StatefulWidget {
  final _ActionItem item;
  const _HomeActionCard({required this.item});

  @override
  State<_HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<_HomeActionCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); context.go(widget.item.route); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.item.gradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.item.color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: widget.item.color.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.item.icon, color: widget.item.color, size: 48),
              ),
              const SizedBox(height: 12),
              Text(
                widget.item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: CivicShieldTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.item.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: CivicShieldTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final String route;
  const _SecondaryActionTile({
    required this.icon, required this.label, required this.subtitle,
    required this.color, required this.bgColor, required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: CivicShieldTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _QuickPill({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.35), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
