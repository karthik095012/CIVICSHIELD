import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../app/theme.dart';
import '../../providers/hotspot_provider.dart';
import '../../models/hotspot_model.dart';
import '../../widgets/custom_cards.dart';
import '../../widgets/custom_widgets.dart';

class CommunityHotspotScreen extends ConsumerStatefulWidget {
  const CommunityHotspotScreen({super.key});

  @override
  ConsumerState<CommunityHotspotScreen> createState() => _CommunityHotspotScreenState();
}

class _CommunityHotspotScreenState extends ConsumerState<CommunityHotspotScreen>
    with SingleTickerProviderStateMixin {
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
    final hotspotsAsync = ref.watch(hotspotProvider);
    
    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        elevation: 0,
        title: const Text(
          'Community Hotspots',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: CivicShieldTheme.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: CivicShieldTheme.accentCyan,
                labelColor: CivicShieldTheme.accentCyan,
                unselectedLabelColor: CivicShieldTheme.textMuted,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('List'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Map'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: hotspotsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: CivicShieldTheme.accentCyan,
          ),
        ),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: CivicShieldTheme.dangerRed),
              const SizedBox(height: 16),
              Text('Error: $e', style: const TextStyle(color: CivicShieldTheme.textSecondary)),
            ],
          ),
        ),
        data: (hotspots) => TabBarView(
          controller: _tabController,
          children: [
            _buildListView(hotspots),
            _buildMapView(hotspots),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<HotspotModel> hotspots) {
    final active = hotspots.where((h) => h.status == 'active').toList();
    final highSev = hotspots.where((h) => h.severityLevel == 'high').length;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: CivicShieldTheme.surfaceCard,
            border: Border(
              bottom: BorderSide(color: CivicShieldTheme.borderGlow, width: 1),
            ),
          ),
          child: Row(
            children: [
              _StatBadge('${hotspots.length}', 'Total', CivicShieldTheme.infoBlue),
              const SizedBox(width: 8),
              _StatBadge('${active.length}', 'Active', CivicShieldTheme.warningOrange),
              const SizedBox(width: 8),
              _StatBadge('$highSev', 'High Severity', CivicShieldTheme.dangerRed),
            ],
          ),
        ),
        Expanded(
          child: hotspots.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.location_off_rounded, size: 48, color: CivicShieldTheme.textMuted),
                      SizedBox(height: 16),
                      Text(
                        'No hotspots found',
                        style: TextStyle(color: CivicShieldTheme.textSecondary),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: hotspots.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HotspotCard(
                      hotspot: hotspots[i],
                      onTap: () => _showHotspotDetail(context, hotspots[i]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildMapView(List<HotspotModel> hotspots) {
    final activeHotspots = hotspots.where((h) => h.status != 'resolved').toList();
    final mapController = MapController();

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const LatLng(12.9716, 77.5946),
            initialZoom: 13,
            maxZoom: 19,
            minZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.civicshield',
              maxNativeZoom: 19,
            ),
            MarkerLayer(
              markers: activeHotspots.map((hotspot) {
                final color = CivicShieldTheme.severityColor(hotspot.severityLevel);
                return Marker(
                  point: LatLng(hotspot.lat, hotspot.lng),
                  width: 68,
                  height: 80,
                  child: GestureDetector(
                    onTap: () => _showHotspotDetail(context, hotspot),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.7),
                                blurRadius: 12,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            CivicShieldTheme.issueIcon(hotspot.issueCategory),
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: color, width: 1.5),
                          ),
                          child: Text(
                            '${hotspot.reportCount}',
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        // Location label - Top Left
        Positioned(
          top: 12,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Text(
              '📍 Bangalore Civic Map',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // Legend - Bottom Right
        Positioned(
          bottom: 20,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Severity Levels',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _LegendDot(CivicShieldTheme.dangerRed, 'High'),
                const SizedBox(height: 6),
                _LegendDot(CivicShieldTheme.medSeverity, 'Medium'),
                const SizedBox(height: 6),
                _LegendDot(CivicShieldTheme.successGreen, 'Low'),
              ],
            ),
          ),
        ),
        // Hotspots info - Bottom Left
        Positioned(
          bottom: 20,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activeHotspots.length} Active Hotspots',
                  style: const TextStyle(
                    color: CivicShieldTheme.primaryDeepTeal,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap markers for details',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showHotspotDetail(BuildContext context, HotspotModel hotspot) {
    final color = CivicShieldTheme.severityColor(hotspot.severityLevel);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: CivicShieldTheme.surfaceCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: CivicShieldTheme.borderGlow, width: 1)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) => ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CivicShieldTheme.borderGlow,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CivicShieldTheme.issueIcon(hotspot.issueCategory),
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotspot.areaName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: CivicShieldTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            hotspot.severityLevel.toUpperCase(),
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                hotspot.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: CivicShieldTheme.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _Chip('${hotspot.reportCount} Reports', color),
                  const SizedBox(width: 8),
                  if (hotspot.daysUnresolved > 0)
                    _Chip('${hotspot.daysUnresolved} Days Open', CivicShieldTheme.warningOrange),
                ],
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: 'Details',
                subtitle: 'Incident information',
              ),
              const SizedBox(height: 12),
              _DetailRow('Issue Type', hotspot.issueCategory.replaceAll('_', ' ').toUpperCase()),
              const SizedBox(height: 12),
              _DetailRow('Status', hotspot.status.replaceAll('_', ' ').toUpperCase()),
              const SizedBox(height: 12),
              _DetailRow('Community Support', '${hotspot.supportCount} people'),
              const SizedBox(height: 12),
              _DetailRow('Location', '${hotspot.lat.toStringAsFixed(4)}, ${hotspot.lng.toStringAsFixed(4)}'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotspotCard extends ConsumerWidget {
  final HotspotModel hotspot;
  final VoidCallback onTap;

  const _HotspotCard({
    required this.hotspot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = CivicShieldTheme.severityColor(hotspot.severityLevel);
    final issueColor = CivicShieldTheme.issueColor(hotspot.issueCategory);
    final hasSupported = ref.read(hotspotProvider.notifier).hasSupported(hotspot.id);

    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: issueColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  CivicShieldTheme.issueIcon(hotspot.issueCategory),
                  color: issueColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotspot.areaName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: CivicShieldTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            hotspot.severityLevel.toUpperCase(),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (hotspot.status == 'resolved') ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: CivicShieldTheme.successGreen.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'RESOLVED',
                              style: TextStyle(
                                color: CivicShieldTheme.successGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${hotspot.reportCount}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: CivicShieldTheme.textPrimary,
                    ),
                  ),
                  const Text(
                    'reports',
                    style: TextStyle(
                      fontSize: 10,
                      color: CivicShieldTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hotspot.description,
            style: const TextStyle(
              fontSize: 12,
              color: CivicShieldTheme.textSecondary,
              height: 1.5,
            ),
          ),
          if (hotspot.daysUnresolved > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: CivicShieldTheme.warningOrange,
                ),
                const SizedBox(width: 6),
                Text(
                  '${hotspot.daysUnresolved} days unresolved',
                  style: const TextStyle(
                    color: CivicShieldTheme.warningOrange,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          GestureDetector(
            onTap: hasSupported ? null : () => ref.read(hotspotProvider.notifier).addSupport(hotspot.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: hasSupported ? CivicShieldTheme.dangerRed.withOpacity(0.12) : CivicShieldTheme.surfaceCardLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasSupported ? CivicShieldTheme.dangerRed : CivicShieldTheme.borderGlow,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasSupported ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 16,
                    color: hasSupported ? CivicShieldTheme.dangerRed : CivicShieldTheme.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasSupported
                        ? 'Confirmed (+${hotspot.supportCount})'
                        : 'I Experienced This Too',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: hasSupported
                          ? CivicShieldTheme.dangerRed
                          : CivicShieldTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String count, label;
  final Color color;

  const _StatBadge(this.count, this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.4), width: 1),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: CivicShieldTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: const TextStyle(
          color: CivicShieldTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.4), width: 1),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: CivicShieldTheme.textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          color: CivicShieldTheme.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

