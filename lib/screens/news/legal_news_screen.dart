import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme.dart';
import '../../models/legal_news_model.dart';
import '../../providers/legal_news_provider.dart';

class LegalNewsScreen extends ConsumerWidget {
  const LegalNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(legalNewsProvider);
    final notifier = ref.read(legalNewsProvider.notifier);

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        title: const Text('Bills & Law Updates'),
        actions: [
          IconButton(
            tooltip: 'Refresh now',
            onPressed: newsState.isRefreshing ? null : notifier.refreshNow,
            icon: newsState.isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: CivicShieldTheme.accentCyan),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: CivicShieldTheme.borderGlow),
        ),
      ),
      body: newsState.isLoading
          ? const Center(child: CircularProgressIndicator(color: CivicShieldTheme.accentCyan))
          : RefreshIndicator(
              onRefresh: notifier.refreshNow,
              color: CivicShieldTheme.accentCyan,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                children: [
                  _NewsStatusCard(state: newsState),
                  const SizedBox(height: 12),
                  const _OfficialSourcesRow(),
                  if (newsState.error != null && newsState.items.isEmpty) ...[
                    const SizedBox(height: 20),
                    _ErrorEmptyState(message: newsState.error!),
                  ] else ...[
                    const SizedBox(height: 14),
                    ...newsState.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _LegalNewsCard(item: item),
                        )),
                  ],
                ],
              ),
            ),
    );
  }
}

class _NewsStatusCard extends StatelessWidget {
  final LegalNewsState state;
  const _NewsStatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final formattedTime = state.lastUpdated == null
        ? 'Not synced yet'
        : DateFormat('dd MMM yyyy, hh:mm a').format(state.lastUpdated!);
    final status = state.staleCache
        ? 'Showing last cached updates. Pull down to retry.'
        : 'Auto-updated daily. Pull down anytime for a fresh fetch.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)]),
        border: Border.all(color: const Color(0xFF66BB6A).withOpacity(0.45), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.newspaper_rounded, size: 18, color: Color(0xFF1B5E20)),
              SizedBox(width: 8),
              Text(
                'Daily legal intelligence',
                style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1B5E20), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 6),
          Text(
            'Last synced: $formattedTime',
            style: const TextStyle(color: Color(0xFF33691E), fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _OfficialSourcesRow extends StatelessWidget {
  const _OfficialSourcesRow();

  @override
  Widget build(BuildContext context) {
    final links = [
      _SourceLink(label: 'PRS Bill Track', url: 'https://prsindia.org/billtrack'),
      _SourceLink(label: 'Lok Sabha Bills', url: 'https://loksabha.nic.in/Legislation/billintroduce.aspx'),
      _SourceLink(label: 'eGazette', url: 'https://egazette.gov.in/'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Official resources',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: CivicShieldTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: links
              .map((link) => ActionChip(
                    label: Text(link.label),
                    onPressed: () => _openExternal(context, link.url),
                    avatar: const Icon(Icons.open_in_new_rounded, size: 15),
                    side: BorderSide(color: CivicShieldTheme.borderGlow.withOpacity(0.8)),
                    backgroundColor: CivicShieldTheme.surfaceCard,
                    labelStyle: const TextStyle(fontSize: 11, color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w600),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _LegalNewsCard extends StatelessWidget {
  final LegalNewsItem item;
  const _LegalNewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CivicShieldTheme.borderGlow),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: CivicShieldTheme.textPrimary, height: 1.35),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.public_rounded, size: 14, color: CivicShieldTheme.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.source,
                  style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textSecondary, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _timeAgo(item.publishedAt),
                style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textMuted),
              ),
            ],
          ),
          if (item.summary.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              item.summary,
              style: const TextStyle(fontSize: 12, color: CivicShieldTheme.textSecondary, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openExternal(context, item.url),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorEmptyState extends StatelessWidget {
  final String message;
  const _ErrorEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF9A9A)),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 34, color: Color(0xFFC62828)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFFB71C1C), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SourceLink {
  final String label;
  final String url;
  const _SourceLink({required this.label, required this.url});
}

Future<void> _openExternal(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid link')),
    );
    return;
  }

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open link')),
    );
  }
}

String _timeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) {
    return 'Just now';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  }
  return DateFormat('dd MMM').format(dateTime);
}