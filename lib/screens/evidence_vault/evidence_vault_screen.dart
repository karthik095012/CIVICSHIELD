import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../models/incident_report_model.dart';
import '../../providers/report_provider.dart';
import '../../widgets/3d_scene/scene_3d.dart';
import '../../widgets/3d_scene/incident_3d.dart';
import '../../widgets/3d_scene/vector3.dart';

class EvidenceVaultScreen extends ConsumerStatefulWidget {
  const EvidenceVaultScreen({super.key});

  @override
  ConsumerState<EvidenceVaultScreen> createState() => _EvidenceVaultScreenState();
}

class _EvidenceVaultScreenState extends ConsumerState<EvidenceVaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        title: const Text('Evidence Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, size: 20),
            onPressed: () => _showVaultInfo(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(height: 1, color: CivicShieldTheme.borderGlow),
              TabBar(
                controller: _tabController,
                indicatorColor: CivicShieldTheme.accentCyan,
                labelColor: CivicShieldTheme.accentCyan,
                unselectedLabelColor: CivicShieldTheme.textMuted,
                tabs: const [
                  Tab(text: 'List View'),
                  Tab(text: '3D Visualization'),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _CreateIncidentScreen())),
        backgroundColor: CivicShieldTheme.accentCyan,
        foregroundColor: CivicShieldTheme.textOnAccent,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Incident', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: reports.isEmpty 
        ? _buildEmptyVault() 
        : TabBarView(
            controller: _tabController,
            children: [
              _buildReportsList(reports, context),
              _build3DScene(reports),
            ],
          ),
    );
  }

  Widget _buildEmptyVault() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CivicShieldTheme.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF9B59B6).withOpacity(0.4)),
            ),
            child: const Icon(Icons.lock_rounded, size: 40, color: Color(0xFF9B59B6)),
          ),
          const SizedBox(height: 20),
          const Text('Your vault is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Securely store civic incidents. Each record includes timestamp, location, and an AI-generated summary.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CivicShieldTheme.textMuted, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList(List<IncidentReportModel> reports, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: reports.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return _buildVaultHeader(reports.length);
        final report = reports[i - 1];
        return _IncidentCard(report: report);
      },
    );
  }

  Widget _buildVaultHeader(int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2A1A4A), Color(0xFF1A0F2E)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9B59B6).withOpacity(0.4)),
      ),
      child: Row(children: [
        const Icon(Icons.lock_rounded, color: Color(0xFF9B59B6), size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$count Incident${count != 1 ? 's' : ''} Stored', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14)),
          const Text('Encrypted • Stored locally • Exportable', style: TextStyle(fontSize: 11, color: Color(0xFF9B59B6))),
        ])),
      ]),
    );
  }

  Widget _build3DScene(List<IncidentReportModel> reports) {
    // Convert reports to 3D incidents
    final incidents = reports.asMap().entries.map((entry) {
      final i = entry.key;
      final report = entry.value;
      
      // Create a 3D position based on report properties
      // X: category, Y: severity (amount), Z: time
      final categoryX = _getCategoryX(report.violationCategory);
      final amountY = (report.amountAsked ?? report.amountPaid ?? 0).toDouble() / 100; // Scale amount
      final timeZ = -i * 50.0; // Spread over Z axis
      
      return Incident3D(
        id: report.id,
        type: _getIncidentType(report.violationCategory),
        position: Vector3(categoryX, amountY, timeZ),
        description: report.notes.isEmpty ? 'Incident Report' : report.notes,
        date: report.timestamp,
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '3D Incident Visualization',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CivicShieldTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Interactive 3D representation of your incidents in space.',
            style: TextStyle(
              fontSize: 12,
              color: CivicShieldTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Scene3D(
              incidents: incidents,
              width: MediaQuery.of(context).size.width - 32,
              height: 450,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CivicShieldTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CivicShieldTheme.borderGlow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How to Navigate:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CivicShieldTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildNavigationTip('🖱️ Drag', 'Rotate the 3D view'),
                _buildNavigationTip('📌 Pinch', 'Zoom in/out'),
                _buildNavigationTip('🔄 Reset', 'Return to default view'),
                const SizedBox(height: 8),
                const Text(
                  'Axes: X = Category | Y = Amount | Z = Timeline',
                  style: TextStyle(
                    fontSize: 11,
                    color: CivicShieldTheme.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildNavigationTip(String action, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$action - $description',
        style: const TextStyle(fontSize: 12, color: CivicShieldTheme.textSecondary),
      ),
    );
  }

  double _getCategoryX(String? category) {
    switch (category?.toLowerCase()) {
      case 'traffic fine':
        return -80.0;
      case 'parking fine':
        return 0.0;
      case 'regulatory fine':
        return 80.0;
      default:
        return 0.0;
    }
  }

  String _getIncidentType(String? category) {
    switch (category?.toLowerCase()) {
      case 'traffic fine':
        return 'traffic';
      case 'parking fine':
        return 'parking';
      case 'regulatory fine':
        return 'regulatory';
      default:
        return 'traffic';
    }
  }

  void _showVaultInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: CivicShieldTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: CivicShieldTheme.borderGlow)),
        title: const Text('About Evidence Vault', style: TextStyle(color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text(
          'Your Evidence Vault stores civic incident records securely on your device. Each record includes:\n\n• Timestamp and location\n• Issue details and amount\n• AI-generated complaint summary\n• Status tracking\n\nData is stored locally and never sent to external servers without your consent.',
          style: TextStyle(color: CivicShieldTheme.textSecondary, height: 1.5, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it', style: TextStyle(color: CivicShieldTheme.accentCyan))),
        ],
      ),
    );
  }
}

class _IncidentCard extends ConsumerWidget {
  final IncidentReportModel report;
  const _IncidentCard({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(report.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CivicShieldTheme.borderGlow),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(report.issueTypeDisplay, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: CivicShieldTheme.textPrimary)),
              const SizedBox(height: 3),
              Text('${report.violationCategory} • ${report.formattedDate}', style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textMuted)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.4)),
              ),
              child: Text(report.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.location_on_rounded, size: 13, color: CivicShieldTheme.textMuted),
            const SizedBox(width: 4),
            Expanded(child: Text(report.locationName, style: const TextStyle(fontSize: 12, color: CivicShieldTheme.textSecondary))),
          ]),
          if (report.amountAsked != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.currency_rupee_rounded, size: 13, color: CivicShieldTheme.dangerRed),
              const SizedBox(width: 4),
              Text('₹${report.amountAsked!.toStringAsFixed(0)} demanded', style: const TextStyle(fontSize: 12, color: CivicShieldTheme.dangerRed, fontWeight: FontWeight.w600)),
            ]),
          ],
          if (report.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(report.notes, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: CivicShieldTheme.textMuted, height: 1.4)),
          ],
          if (report.aiSummary != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showSummary(context, report.aiSummary!),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CivicShieldTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CivicShieldTheme.infoBlue.withOpacity(0.3)),
                ),
                child: const Row(children: [
                  Icon(Icons.auto_awesome_rounded, size: 13, color: CivicShieldTheme.infoBlue),
                  SizedBox(width: 6),
                  Text('AI Summary ready — tap to view & export', style: TextStyle(color: CivicShieldTheme.infoBlue, fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(children: [
            Icon(report.isAnonymous ? Icons.visibility_off_rounded : Icons.person_rounded, size: 13, color: CivicShieldTheme.textMuted),
            const SizedBox(width: 4),
            Text(report.isAnonymous ? 'Anonymous' : 'Named', style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textMuted)),
            const Spacer(),
            GestureDetector(
              onTap: () => ref.read(reportProvider.notifier).deleteReport(report.id),
              child: const Icon(Icons.delete_outline_rounded, size: 18, color: CivicShieldTheme.textMuted),
            ),
          ]),
        ]),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'submitted': return CivicShieldTheme.infoBlue;
      case 'exported': return CivicShieldTheme.successGreen;
      case 'unresolved': return CivicShieldTheme.dangerRed;
      default: return CivicShieldTheme.warningOrange;
    }
  }

  void _showSummary(BuildContext context, String summary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CivicShieldTheme.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: CivicShieldTheme.borderGlow, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            const Row(children: [
              Icon(Icons.auto_awesome_rounded, color: CivicShieldTheme.accentCyan, size: 18),
              SizedBox(width: 8),
              Text('AI Generated Report', style: TextStyle(fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary, fontSize: 16)),
            ]),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Text(summary, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 12, fontFamily: 'monospace', height: 1.6)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _CreateIncidentScreen extends StatelessWidget {
  const _CreateIncidentScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(backgroundColor: CivicShieldTheme.surfaceDark, title: const Text('New Incident Record')),
      body: const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.edit_note_rounded, size: 48, color: CivicShieldTheme.accentCyan),
          SizedBox(height: 16),
          Text('Use Report Misuse for guided form', style: TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 15)),
          SizedBox(height: 6),
          Text('or fill in incident details below', style: TextStyle(color: CivicShieldTheme.textMuted, fontSize: 13)),
        ]),
      ),
    );
  }
}
