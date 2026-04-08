import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../app/theme.dart';
import '../../providers/legal_services_provider.dart';
import '../../models/legal_service_location_model.dart';

class LegalServicesMapScreen extends ConsumerStatefulWidget {
  const LegalServicesMapScreen({super.key});

  @override
  ConsumerState<LegalServicesMapScreen> createState() => _LegalServicesMapScreenState();
}

class _LegalServicesMapScreenState extends ConsumerState<LegalServicesMapScreen>
    with SingleTickerProviderStateMixin {
  late MapController _mapController;
  String _selectedType = 'all'; // all, consultancy, advocate, court, law_clinic
  double _selectedMinRating = 0.0;
  LegalServiceLocation? _selectedService;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = _selectedType == 'all'
        ? ref.watch(legalServicesProvider)
        : ref.watch(legalServicesByTypeProvider(_selectedType));

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        elevation: 0,
        title: const Text(
          'Legal Services Map',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: CivicShieldTheme.textPrimary,
          ),
        ),
      ),
      body: servicesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error loading services: $error'),
        ),
        data: (services) {
          // Filter by rating
          final filtered = services
              .where((s) => s.rating >= _selectedMinRating)
              .toList();

          return Column(
            children: [
              // Filter controls
              _buildFilterBar(context),
              // Map
              Expanded(
                child: _buildMap(filtered),
              ),
              // Bottom sheet with service list
              if (_selectedService != null)
                _buildServiceDetails(_selectedService!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      color: CivicShieldTheme.surfaceCard,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type filter
          Text(
            'Filter by Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Consultancy', 'consultancy'),
                const SizedBox(width: 8),
                _buildFilterChip('Advocates', 'advocate'),
                const SizedBox(width: 8),
                _buildFilterChip('Courts', 'court'),
                const SizedBox(width: 8),
                _buildFilterChip('Law Clinic', 'law_clinic'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Rating filter
          Text(
            'Minimum Rating: ${_selectedMinRating.toStringAsFixed(1)} ⭐',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Slider(
            value: _selectedMinRating,
            min: 0.0,
            max: 5.0,
            divisions: 10,
            activeColor: CivicShieldTheme.accentCyan,
            onChanged: (value) {
              setState(() => _selectedMinRating = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedType = type);
      },
      backgroundColor: Colors.transparent,
      selectedColor: CivicShieldTheme.primaryDeepTeal.withOpacity(0.3),
      side: BorderSide(
        color: isSelected
            ? CivicShieldTheme.primaryDeepTeal
            : Colors.grey[400]!,
      ),
    );
  }

  Widget _buildMap(List<LegalServiceLocation> services) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(13.1939, 77.5941),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.civicshield',
            ),
            MarkerLayer(
              markers: services
                  .map((service) => Marker(
                        point: LatLng(service.latitude, service.longitude),
                        child: _buildMarker(service),
                      ))
                  .toList(),
            ),
          ],
        ),
        // Legend
        Positioned(
          bottom: 16,
          left: 16,
          child: _buildLegend(services),
        ),
      ],
    );
  }

  Widget _buildMarker(LegalServiceLocation service) {
    final icon = _getTypeIcon(service.type);
    final color = _getTypeColor(service.type);

    return GestureDetector(
      onTap: () => setState(() => _selectedService = service),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          // Rating label
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '⭐ ${service.rating}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<LegalServiceLocation> services) {
    final types = _getUniqueTypes(services);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legend',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...types.map((type) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getTypeColor(type),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getTypeIcon(type),
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getTypeLabel(type),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetails(LegalServiceLocation service) {
    return Container(
      decoration: BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getTypeColor(service.type),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTypeIcon(service.type),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            service.getTypeLabel(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (service.isVerified)
                      const Tooltip(
                        message: 'Verified Service',
                        child: Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                  ],
              ),
              const SizedBox(height: 16),
              // Rating and reviews
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: Colors.amber, size: 24),
                  const SizedBox(width: 6),
                  Text(
                    '${service.rating}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${service.reviewCount} reviews)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Availability
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      service.availability == 'open'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: service.availability == 'open'
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.getAvailabilityStatus(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            service.workingHours,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Address
              _buildDetailRow(
                context,
                icon: Icons.location_on_rounded,
                label: 'Address',
                value: service.address,
              ),
              const SizedBox(height: 12),
              // Contact
              _buildDetailRow(
                context,
                icon: Icons.phone_rounded,
                label: 'Contact',
                value: service.contactNumber,
              ),
              const SizedBox(height: 12),
              // Email
              _buildDetailRow(
                context,
                icon: Icons.email_rounded,
                label: 'Email',
                value: service.emailAddress,
              ),
              const SizedBox(height: 16),
              // Specialization
              if (service.specialization.isNotEmpty) ...[
                Text(
                  'Specializations',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: service.specialization
                      .map((spec) => Chip(
                            label: Text(spec.replaceAll('_', ' ').toUpperCase()),
                            backgroundColor:
                                Colors.blue.withOpacity(0.2),
                            labelStyle: const TextStyle(fontSize: 11),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              // Description
              Text(
                'About',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                service.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _contactService(service),
                      icon: const Icon(Icons.phone),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CivicShieldTheme.primaryDeepTeal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _emailService(service),
                      icon: const Icon(Icons.email),
                      label: const Text('Email'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedService = null),
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: CivicShieldTheme.primaryDeepTeal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _contactService(LegalServiceLocation service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Call: ${service.contactNumber}'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy to clipboard functionality
          },
        ),
      ),
    );
  }

  void _emailService(LegalServiceLocation service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email: ${service.emailAddress}'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy to clipboard functionality
          },
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'consultancy':
        return Icons.business_rounded;
      case 'advocate':
        return Icons.gavel_rounded;
      case 'court':
        return Icons.balance_rounded;
      case 'law_clinic':
        return Icons.local_hospital_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'consultancy':
        return Colors.blue;
      case 'advocate':
        return Colors.purple;
      case 'court':
        return Colors.deepOrange;
      case 'law_clinic':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'consultancy':
        return 'Legal Consultancy';
      case 'advocate':
        return 'Advocate';
      case 'court':
        return 'Court';
      case 'law_clinic':
        return 'Law Clinic';
      default:
        return type;
    }
  }

  List<String> _getUniqueTypes(List<LegalServiceLocation> services) {
    final types = services.map((s) => s.type).toSet().toList();
    types.sort((a, b) => _getTypeLabel(a).compareTo(_getTypeLabel(b)));
    return types;
  }
}
