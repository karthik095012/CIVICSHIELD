import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_cards.dart';
import '../../widgets/custom_widgets.dart';
import '../../providers/authority_provider.dart';
import '../../models/authority_model.dart';

class AuthorityDirectoryScreen extends ConsumerStatefulWidget {
  const AuthorityDirectoryScreen({super.key});

  @override
  ConsumerState<AuthorityDirectoryScreen> createState() => _AuthorityDirectoryScreenState();
}

class _AuthorityDirectoryScreenState extends ConsumerState<AuthorityDirectoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authorities = ref.watch(authorityProvider);

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
                          'Authority Directory',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: CivicShieldTheme.textPrimary,
                          ),
                        ),
                        const Text(
                          'Find contact and resources for official authorities',
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
              padding: const EdgeInsets.all(16),
              child: CustomTextField(
                hintText: 'Search authorities, services...',
                prefixIcon: Icons.search_rounded,
                controller: _searchController,
                onChanged: (value) {
                  ref.read(authoritySearchProvider.notifier).state = value;
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: CivicShieldTheme.accentCyan,
                unselectedLabelColor: CivicShieldTheme.textSecondary,
                indicatorColor: CivicShieldTheme.accentCyan,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: [
                  const Tab(text: 'All'),
                  const Tab(text: 'Traffic'),
                  const Tab(text: 'Anti-Corruption'),
                  const Tab(text: 'Consumer'),
                  const Tab(text: 'Legal'),
                  const Tab(text: 'RTI'),
                ],
              ),
            ),
          ),
          authorities.when(
            data: (data) {
              return SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAuthorityList(data, context),
                    _buildAuthorityList(data.where((a) => a.category == 'traffic').toList(), context),
                    _buildAuthorityList(data.where((a) => a.category == 'anticorruption').toList(), context),
                    _buildAuthorityList(data.where((a) => a.category == 'consumer').toList(), context),
                    _buildAuthorityList(data.where((a) => a.category == 'legal').toList(), context),
                    _buildAuthorityList(data.where((a) => a.category == 'rtiaccessibility').toList(), context),
                  ],
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorityList(List<Authority> authorities, BuildContext context) {
    if (authorities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: CivicShieldTheme.textSecondary),
            const SizedBox(height: 16),
            const Text('No authorities found', style: TextStyle(color: CivicShieldTheme.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: authorities.length,
      itemBuilder: (context, index) {
        final authority = authorities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAuthorityCard(authority),
        );
      },
    );
  }

  Widget _buildAuthorityCard(Authority authority) {
    return GlassCard(
      onTap: () => _showAuthorityDetails(authority),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authority.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: CivicShieldTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authority.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CivicShieldTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: CivicShieldTheme.accentCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  authority.helpfulCount.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CivicShieldTheme.accentCyan,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, size: 16, color: CivicShieldTheme.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        authority.phone,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CivicShieldTheme.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: CivicShieldTheme.textSecondary, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  void _showAuthorityDetails(Authority authority) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CivicShieldTheme.surfaceDark,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: CivicShieldTheme.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: CivicShieldTheme.borderGlow)),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    authority.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: CivicShieldTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    authority.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CivicShieldTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.phone_rounded, 'Phone', authority.phone),
                  if (authority.email != null) _buildContactRow(Icons.email_rounded, 'Email', authority.email!),
                  if (authority.website != null) _buildContactRow(Icons.language_rounded, 'Website', authority.website!),
                  _buildContactRow(Icons.location_on_rounded, 'Address', '${authority.address}, ${authority.city}, ${authority.state}'),
                  const SizedBox(height: 24),
                  const Text(
                    'Services',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  ...authority.services.map((service) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 18, color: CivicShieldTheme.successGreen),
                        const SizedBox(width: 8),
                        Text(service, style: const TextStyle(color: CivicShieldTheme.textSecondary)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Call Now',
                          icon: Icons.phone_rounded,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlineCustomButton(
                          label: 'Email',
                          icon: Icons.email_rounded,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CivicShieldTheme.accentCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CivicShieldTheme.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CivicShieldTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
