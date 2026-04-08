import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../models/rights_card_model.dart';
import '../../providers/rights_provider.dart';

class RightsCardsScreen extends ConsumerWidget {
  const RightsCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rightsAsync = ref.watch(rightsProvider);

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Know Your Rights'),
        backgroundColor: CivicShieldTheme.surfaceDark,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: CivicShieldTheme.borderGlow),
        ),
      ),
      body: rightsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: CivicShieldTheme.accentCyan)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (cards) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: cards.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return _buildHeader();
            final card = cards[i - 1];
            return _RightsCard(card: card);
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: CivicShieldTheme.premiumGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CivicShieldTheme.borderGlow),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_rounded, color: CivicShieldTheme.accentCyan, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Civic Rights',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary)),
                SizedBox(height: 4),
                Text('Tap any card to read detailed guidance, dos & don\'ts, and helplines.',
                    style: TextStyle(fontSize: 12, color: CivicShieldTheme.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RightsCard extends StatefulWidget {
  final RightsCardModel card;
  const _RightsCard({required this.card});

  @override
  State<_RightsCard> createState() => _RightsCardState();
}

class _RightsCardState extends State<_RightsCard> {
  bool _expanded = false;
  int _activeTab = 0;

  Color get _cardColor => CivicShieldTheme.categoryColor(widget.card.category);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded ? _cardColor.withOpacity(0.5) : CivicShieldTheme.borderGlow,
          width: _expanded ? 1.5 : 1,
        ),
        boxShadow: _expanded
            ? [BoxShadow(color: _cardColor.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _cardColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(_categoryIcon, color: _cardColor, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _cardColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.card.category.toUpperCase(),
                      style: TextStyle(fontSize: 9, color: _cardColor, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.card.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: CivicShieldTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(widget.card.summary,
                      style: const TextStyle(fontSize: 12, color: CivicShieldTheme.textSecondary, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 280),
              child: const Icon(Icons.keyboard_arrow_down_rounded, color: CivicShieldTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: CivicShieldTheme.borderGlow),
          const SizedBox(height: 8),
          Text(widget.card.details,
              style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 13, height: 1.6)),
          const SizedBox(height: 14),
          _buildTabs(),
          const SizedBox(height: 12),
          _buildTabContent(),
          const SizedBox(height: 14),
          _buildEmergencyContacts(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['What TO Do', 'What NOT To Do', 'Myths vs Facts'];
    return Row(
      children: tabs.asMap().entries.map((e) {
        final isActive = e.key == _activeTab;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = e.key),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? _cardColor : CivicShieldTheme.surfaceCardLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isActive ? _cardColor : CivicShieldTheme.borderGlow),
              ),
              margin: EdgeInsets.only(right: e.key < 2 ? 6 : 0),
              alignment: Alignment.center,
              child: Text(
                e.value,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : CivicShieldTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTabContent() {
    if (_activeTab == 0) {
      return Column(
        children: widget.card.dos.map((d) => _BulletItem(
          text: d,
          icon: Icons.check_circle_rounded,
          color: CivicShieldTheme.successGreen,
        )).toList(),
      );
    } else if (_activeTab == 1) {
      return Column(
        children: widget.card.donts.map((d) => _BulletItem(
          text: d,
          icon: Icons.cancel_rounded,
          color: CivicShieldTheme.dangerRed,
        )).toList(),
      );
    } else {
      return Column(
        children: widget.card.myths.map((m) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CivicShieldTheme.surfaceCardLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CivicShieldTheme.borderGlow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.cancel_outlined, size: 14, color: CivicShieldTheme.dangerRed),
                    SizedBox(width: 6),
                    Text('MYTH', style: TextStyle(fontSize: 10, color: CivicShieldTheme.dangerRed, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(m['myth'] ?? '', style: const TextStyle(color: CivicShieldTheme.textPrimary, fontSize: 12, fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 14, color: CivicShieldTheme.successGreen),
                    SizedBox(width: 6),
                    Text('FACT', style: TextStyle(fontSize: 10, color: CivicShieldTheme.successGreen, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(m['fact'] ?? '', style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.phone_rounded, size: 14, color: CivicShieldTheme.accentCyan),
            SizedBox(width: 6),
            Text('Emergency Contacts', style: TextStyle(color: CivicShieldTheme.accentCyan,
                fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.card.emergencyContacts.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text('• $c', style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 12)),
        )),
      ],
    );
  }

  IconData get _categoryIcon {
    switch (widget.card.category) {
      case 'traffic': return Icons.traffic_rounded;
      case 'anticorruption': return Icons.no_crash_rounded;
      case 'rti': return Icons.info_rounded;
      case 'consumer': return Icons.shopping_bag_rounded;
      case 'women': return Icons.female_rounded;
      case 'legal': return Icons.gavel_rounded;
      case 'police': return Icons.local_police_rounded;
      default: return Icons.shield_rounded;
    }
  }
}



class _BulletItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _BulletItem({required this.text, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
