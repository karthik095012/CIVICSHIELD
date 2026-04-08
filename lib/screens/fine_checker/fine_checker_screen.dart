import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../models/fine_model.dart';
import '../../providers/fine_provider.dart';

class FineCheckerScreen extends ConsumerStatefulWidget {
  const FineCheckerScreen({super.key});

  @override
  ConsumerState<FineCheckerScreen> createState() => _FineCheckerScreenState();
}

class _FineCheckerScreenState extends ConsumerState<FineCheckerScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'all';

  final _categories = const [
    ('all', 'All'),
    ('helmet', 'Helmet'),
    ('seatbelt', 'Seat Belt'),
    ('mobile', 'Mobile Use'),
    ('signal', 'Signal'),
    ('speeding', 'Speeding'),
    ('documents', 'Documents'),
    ('parking', 'Parking'),
    ('emission', 'Emission'),
    ('drunk_driving', 'DUI'),
    ('lane', 'Lane'),
    ('number_plate', 'Plate'),
    ('minor_driving', 'Minor'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finesAsync = ref.watch(fineProvider);

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        title: const Text('Fine Checker'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: CivicShieldTheme.borderGlow),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          const SizedBox(height: 4),
          Expanded(
            child: finesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: CivicShieldTheme.accentCyan)),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (fines) => fines.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: fines.length,
                      itemBuilder: (context, i) => _FineCard(fine: fines[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: CivicShieldTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search violation (e.g. helmet, signal)...',
          prefixIcon: const Icon(Icons.search_rounded, color: CivicShieldTheme.textMuted),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: CivicShieldTheme.textMuted, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(fineProvider.notifier).search('');
                    setState(() {});
                  },
                )
              : null,
        ),
        onChanged: (q) {
          ref.read(fineProvider.notifier).search(q);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final (key, label) = _categories[i];
          final isSelected = _selectedCategory == key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = key);
                ref.read(fineProvider.notifier).setCategory(key);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? CivicShieldTheme.accentCyan : CivicShieldTheme.surfaceCardLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? CivicShieldTheme.accentCyan : CivicShieldTheme.borderGlow,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? CivicShieldTheme.textOnAccent : CivicShieldTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 52, color: CivicShieldTheme.textMuted),
          SizedBox(height: 14),
          Text('No violations found', style: TextStyle(color: CivicShieldTheme.textSecondary, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text('Try a different search term', style: TextStyle(color: CivicShieldTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _FineCard extends StatefulWidget {
  final FineModel fine;
  const _FineCard({required this.fine});

  @override
  State<_FineCard> createState() => _FineCardState();
}

class _FineCardState extends State<_FineCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = CivicShieldTheme.categoryColor(widget.fine.category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded ? color.withOpacity(0.5) : CivicShieldTheme.borderGlow,
          width: _expanded ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(CivicShieldTheme.categoryIcon(widget.fine.category), color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fine.violationName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: CivicShieldTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.fine.stateScope,
                          style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${widget.fine.fineAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                      const Text('1st offense', style: TextStyle(fontSize: 10, color: CivicShieldTheme.textMuted)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: CivicShieldTheme.textMuted, size: 22),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(color),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Color color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: CivicShieldTheme.borderGlow),
          const SizedBox(height: 6),
          Text(widget.fine.description,
              style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 13, height: 1.5)),
          if (widget.fine.repeatOffenseAmount != null) ...[
            const SizedBox(height: 10),
            _FineRow(label: 'Repeat Offense',
                value: '₹${widget.fine.repeatOffenseAmount!.toStringAsFixed(0)}',
                valueColor: CivicShieldTheme.dangerRed),
          ],
          const SizedBox(height: 10),
          _InfoBox(icon: Icons.book_rounded, label: 'Law Reference', text: widget.fine.lawReference, color: color),
          if (widget.fine.firstOffenseNote != null) ...[
            const SizedBox(height: 8),
            _InfoBox(
              icon: Icons.warning_amber_rounded,
              label: 'Important Note',
              text: widget.fine.firstOffenseNote!,
              color: CivicShieldTheme.warningOrange,
            ),
          ],
          if (widget.fine.process != null) ...[
            const SizedBox(height: 8),
            _InfoBox(
              icon: Icons.info_rounded,
              label: 'What Should Happen',
              text: widget.fine.process!,
              color: CivicShieldTheme.infoBlue,
            ),
          ],
        ],
      ),
    );
  }
}

class _FineRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _FineRow({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: valueColor)),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final Color color;
  const _InfoBox({required this.icon, required this.label, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(text, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
