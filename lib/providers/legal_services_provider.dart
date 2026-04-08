import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/legal_service_location_model.dart';

// Provider for legal services locations
final legalServicesProvider =
    FutureProvider<List<LegalServiceLocation>>((ref) async {
  final jsonString =
      await rootBundle.loadString('assets/data/legal_services.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList
      .map((json) => LegalServiceLocation.fromJson(json as Map<String, dynamic>))
      .toList();
});

// Filter by type
final legalServicesByTypeProvider =
    FutureProvider.family<List<LegalServiceLocation>, String>((ref, type) async {
  final services = await ref.watch(legalServicesProvider.future);
  return services.where((s) => s.type == type).toList();
});

// Filter by rating (minimum rating)
final legalServicesByRatingProvider = FutureProvider.family<
    List<LegalServiceLocation>,
    double>((ref, minRating) async {
  final services = await ref.watch(legalServicesProvider.future);
  return services.where((s) => s.rating >= minRating).toList();
});

// Filter by specialization
final legalServicesBySpecializationProvider = FutureProvider.family<
    List<LegalServiceLocation>,
    String>((ref, specialization) async {
  final services = await ref.watch(legalServicesProvider.future);
  return services
      .where((s) => s.specialization.contains(specialization))
      .toList();
});

// Sort by rating (highest first)
final legalServicesSortedByRatingProvider =
    FutureProvider<List<LegalServiceLocation>>((ref) async {
  final services = await ref.watch(legalServicesProvider.future);
  final sorted = [...services];
  sorted.sort((a, b) => b.rating.compareTo(a.rating));
  return sorted;
});

// Sort by proximity (would need user location)
final nearbyLegalServicesProvider = FutureProvider.family<
    List<LegalServiceLocation>,
    ({double latitude, double longitude})>((ref, userLocation) async {
  final services = await ref.watch(legalServicesProvider.future);
  
  // Calculate distance using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  final servicesWithDistance = services.map((service) {
    final distance = calculateDistance(
      userLocation.latitude,
      userLocation.longitude,
      service.latitude,
      service.longitude,
    );
    return (service: service, distance: distance);
  }).toList();

  servicesWithDistance.sort((a, b) => a.distance.compareTo(b.distance));
  return servicesWithDistance.map((e) => e.service).toList();
});

double _toRad(double degree) {
  return degree * (3.14159265359 / 180);
}


