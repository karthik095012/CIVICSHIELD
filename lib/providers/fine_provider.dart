import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fine_model.dart';

class FineNotifier extends StateNotifier<AsyncValue<List<FineModel>>> {
  FineNotifier() : super(const AsyncValue.loading()) {
    loadFines();
  }

  List<FineModel> _allFines = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';

  Future<void> loadFines() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/fines.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List;
      _allFines = jsonList.map((j) => FineModel.fromJson(j as Map<String, dynamic>)).toList();
      state = AsyncValue.data(_filteredFines());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<FineModel> _filteredFines() {
    return _allFines.where((fine) {
      final matchesSearch = _searchQuery.isEmpty ||
          fine.violationName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fine.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fine.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'all' || fine.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void search(String query) {
    _searchQuery = query;
    if (_allFines.isNotEmpty) {
      state = AsyncValue.data(_filteredFines());
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    if (_allFines.isNotEmpty) {
      state = AsyncValue.data(_filteredFines());
    }
  }

  List<String> get categories {
    final cats = _allFines.map((f) => f.category).toSet().toList();
    cats.sort();
    return cats;
  }
}

final fineProvider = StateNotifierProvider<FineNotifier, AsyncValue<List<FineModel>>>((ref) {
  return FineNotifier();
});

final fineCategoryProvider = StateProvider<String>((ref) => 'all');
final fineSearchProvider = StateProvider<String>((ref) => '');
