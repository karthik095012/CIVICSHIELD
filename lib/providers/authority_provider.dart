import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/authority_model.dart';

final authorityProvider = StateNotifierProvider<AuthorityNotifier, AsyncValue<List<Authority>>>((ref) {
  return AuthorityNotifier();
});

final authoritySearchProvider = StateProvider<String>((ref) => '');

final filteredAuthoritiesProvider = FutureProvider<List<Authority>>((ref) {
  final search = ref.watch(authoritySearchProvider);
  final authorities = ref.watch(authorityProvider);

  return authorities.when(
    data: (list) {
      if (search.isEmpty) return list;
      return list
          .where((auth) =>
              auth.name.toLowerCase().contains(search.toLowerCase()) ||
              auth.category.toLowerCase().contains(search.toLowerCase()) ||
              auth.city.toLowerCase().contains(search.toLowerCase()))
          .toList();
    },
    loading: () => Future.value([]),
    error: (err, stack) => Future.error(err, stack),
  );
});

final authoritiesByCategoryProvider = FutureProvider.family<List<Authority>, String>((ref, category) async {
  final authorities = ref.watch(authorityProvider);
  return authorities.when(
    data: (list) => list.where((auth) => auth.category == category).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

class AuthorityNotifier extends StateNotifier<AsyncValue<List<Authority>>> {
  AuthorityNotifier() : super(const AsyncValue.loading()) {
    _loadAuthorities();
  }

  Future<void> _loadAuthorities() async {
    try {
      // TODO: Replace with actual API call or local database query
      await Future.delayed(const Duration(milliseconds: 500));
      final mockAuthorities = _getMockAuthorities();
      state = AsyncValue.data(mockAuthorities);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  List<Authority> _getMockAuthorities() {
    return [
      Authority(
        name: 'Traffic Police - Central Division',
        description: 'Traffic law enforcement for central city areas',
        category: 'traffic',
        phone: '100',
        email: 'traffic@citypd.gov.in',
        website: 'www.trafficpolicecity.gov.in',
        address: '123 Police Headquarters, Main Road',
        city: 'Bangalore',
        state: 'Karnataka',
        latitude: 12.9716,
        longitude: 77.5946,
        services: ['Traffic violation fines', 'Vehicle registration', 'Driving license'],
        helpfulCount: 245,
      ),
      Authority(
        name: 'Public Grievance Bureau',
        description: 'Anti-corruption and public grievance redressal',
        category: 'anticorruption',
        phone: '+91-80-2234-5678',
        email: 'grievance@pgb.gov.in',
        website: 'www.publicgrievance.gov.in',
        address: '456 Government Complex, West Wing',
        city: 'Bangalore',
        state: 'Karnataka',
        latitude: 12.9622,
        longitude: 77.6007,
        services: ['Complaint filing', 'Grievance tracking', 'Official misconduct complaints'],
        helpfulCount: 189,
      ),
      Authority(
        name: 'Consumer Rights Commission',
        description: 'Consumer protection and rights enforcement',
        category: 'consumer',
        phone: '1800-11-4000',
        email: 'complaints@consumerrights.gov.in',
        website: 'www.consumerrights.gov.in',
        address: '789 Consumer Bhavan, Civil Lines',
        city: 'Bangalore',
        state: 'Karnataka',
        latitude: 12.9667,
        longitude: 77.5833,
        services: ['Consumer complaints', 'Refund assistance', 'Fraud reporting'],
        helpfulCount: 156,
      ),
      Authority(
        name: 'Legal Aid Society',
        description: 'Free legal aid and consultation services',
        category: 'legal',
        phone: '+91-80-2111-2222',
        email: 'legalaid@society.gov.in',
        website: 'www.legalaid.gov.in',
        address: '321 Law Courts, Fort Area',
        city: 'Bangalore',
        state: 'Karnataka',
        latitude: 12.9739,
        longitude: 77.5915,
        services: ['Legal consultation', 'Case filing', 'Court representation'],
        helpfulCount: 198,
      ),
      Authority(
        name: 'RTI Information Office',
        description: 'Right to Information request processing',
        category: 'rtiaccessibility',
        phone: '+91-80-2268-1234',
        email: 'rti@government.gov.in',
        website: 'www.rti.gov.in',
        address: '654 Government Secretariat',
        city: 'Bangalore',
        state: 'Karnataka',
        latitude: 12.9676,
        longitude: 77.5773,
        services: ['RTI requests', 'Information access', 'Document procurement'],
        helpfulCount: 134,
      ),
    ];
  }

  void updateSearch(String query) {
    // Handled by the searchProvider
  }
}
