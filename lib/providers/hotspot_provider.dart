import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hotspot_model.dart';

class HotspotNotifier extends StateNotifier<AsyncValue<List<HotspotModel>>> {
  HotspotNotifier() : super(const AsyncValue.loading()) {
    loadHotspots();
  }

  List<HotspotModel> _allHotspots = [];
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';
  final Set<String> _supportedIds = {};

  Future<void> loadHotspots() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/hotspots.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List;
      _allHotspots = jsonList.map((j) => HotspotModel.fromJson(j as Map<String, dynamic>)).toList();
      state = AsyncValue.data(_filteredHotspots());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<HotspotModel> _filteredHotspots() {
    return _allHotspots.where((h) {
      final matchesCat = _selectedCategory == 'all' || h.issueCategory == _selectedCategory;
      final matchesStatus = _selectedStatus == 'all' || h.status == _selectedStatus;
      return matchesCat && matchesStatus;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    if (_allHotspots.isNotEmpty) state = AsyncValue.data(_filteredHotspots());
  }

  void setStatus(String status) {
    _selectedStatus = status;
    if (_allHotspots.isNotEmpty) state = AsyncValue.data(_filteredHotspots());
  }

  bool hasSupported(String hotspotId) => _supportedIds.contains(hotspotId);

  void addSupport(String hotspotId) {
    if (_supportedIds.contains(hotspotId)) return;
    _supportedIds.add(hotspotId);
    final idx = _allHotspots.indexWhere((h) => h.id == hotspotId);
    if (idx >= 0) {
      _allHotspots[idx] = _allHotspots[idx].copyWith(
        supportCount: _allHotspots[idx].supportCount + 1,
      );
      state = AsyncValue.data(_filteredHotspots());
    }
  }

  List<HotspotModel> get allHotspots => _allHotspots;

  List<String> get categories => ['all', 'overcharging', 'no_receipt', 'bribe_request', 'pothole', 'streetlight', 'garbage'];
}

final hotspotProvider = StateNotifierProvider<HotspotNotifier, AsyncValue<List<HotspotModel>>>((ref) {
  return HotspotNotifier();
});
