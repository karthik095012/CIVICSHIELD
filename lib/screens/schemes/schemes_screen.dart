import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme.dart';
import '../../models/scheme_model.dart';
import '../../providers/scheme_provider.dart';

class SchemesScreen extends ConsumerWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemesAsync = ref.watch(schemeProvider);
    final notifier = ref.read(schemeProvider.notifier);

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        title: const Text('Govt Schemes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded, size: 22),
            color: CivicShieldTheme.accentCyan,
            onPressed: () => notifier.toggleBookmarkOnly(),
            tooltip: 'Saved Schemes',
          ),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: CivicShieldTheme.borderGlow)),
      ),
      body: schemesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: CivicShieldTheme.accentCyan)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (schemes) => Column(children: [
          _buildCategoryChips(ref, notifier),
          Expanded(child: schemes.isEmpty
              ? const Center(child: Text('No schemes found', style: TextStyle(color: CivicShieldTheme.textMuted)))
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: schemes.length,
            itemBuilder: (ctx, i) => _SchemeCard(scheme: schemes[i]),
          )),
        ]),
      ),
    );
  }

  Widget _buildCategoryChips(WidgetRef ref, SchemeNotifier notifier) {
    return Consumer(builder: (_, ref, __) {
      final schemesAsync = ref.watch(schemeProvider);
      final cats = schemesAsync.value != null ? notifier.categories : ['all'];
      return SizedBox(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length,
          itemBuilder: (_, i) {
            final cat = cats[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => notifier.setCategory(cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: CivicShieldTheme.surfaceCardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: CivicShieldTheme.borderGlow),
                  ),
                  child: Text(cat == 'all' ? 'All' : cat,
                      style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _SchemeCard extends ConsumerWidget {
  final SchemeModel scheme;
  const _SchemeCard({required this.scheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catColor = _catColor(scheme.category);
    final isBookmarked = scheme.isBookmarked;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CivicShieldTheme.borderGlow),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [catColor.withOpacity(0.12), Colors.transparent], end: Alignment.centerRight),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: catColor.withOpacity(0.15), borderRadius: BorderRadius.circular(9)),
              child: Icon(_catIcon(scheme.category), color: catColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(scheme.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: CivicShieldTheme.textPrimary)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(5)),
                child: Text(scheme.category, style: TextStyle(fontSize: 10, color: catColor, fontWeight: FontWeight.w600)),
              ),
            ])),
            GestureDetector(
              onTap: () => ref.read(schemeProvider.notifier).toggleBookmark(scheme.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isBookmarked ? CivicShieldTheme.accentCyan : CivicShieldTheme.textMuted,
                  size: 22,
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(scheme.description, style: const TextStyle(fontSize: 12, color: CivicShieldTheme.textSecondary, height: 1.5)),
            const SizedBox(height: 10),
            _InfoRow(Icons.star_rounded, 'Benefit', scheme.benefitAmount, CivicShieldTheme.accentCyan),
            const SizedBox(height: 6),
            _InfoRow(Icons.check_circle_rounded, 'Eligibility', scheme.eligibility, CivicShieldTheme.successGreen),
            const SizedBox(height: 6),
            _InfoRow(Icons.calendar_today_rounded, 'Deadline', scheme.deadline, CivicShieldTheme.infoBlue),
            const SizedBox(height: 6),
            _InfoRow(Icons.flag_rounded, 'Scope', scheme.stateScope, CivicShieldTheme.warningOrange),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(scheme.officialLink);
                  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Apply Now — Official Portal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: catColor,
                  foregroundColor: CivicShieldTheme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Agriculture': return const Color(0xFF27AE60);
      case 'Health': return const Color(0xFFE74C3C);
      case 'Housing': return const Color(0xFF3498DB);
      case 'Women & Child': return const Color(0xFFE91E63);
      case 'Business/MSME': return const Color(0xFFF39C12);
      case 'Senior Citizens': return const Color(0xFF9B59B6);
      case 'Education': return const Color(0xFF1ABC9C);
      case 'Disability': return const Color(0xFF2196F3);
      default: return CivicShieldTheme.primaryMidTeal;
    }
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'Agriculture': return Icons.agriculture_rounded;
      case 'Health': return Icons.health_and_safety_rounded;
      case 'Housing': return Icons.home_rounded;
      case 'Women & Child': return Icons.child_care_rounded;
      case 'Business/MSME': return Icons.business_rounded;
      case 'Senior Citizens': return Icons.elderly_rounded;
      case 'Education': return Icons.school_rounded;
      case 'Disability': return Icons.accessibility_rounded;
      default: return Icons.account_balance_rounded;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoRow(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 6),
      SizedBox(width: 70, child: Text(label, style: const TextStyle(color: CivicShieldTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600))),
      Expanded(child: Text(value, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 11, height: 1.4))),
    ]);
  }
}
