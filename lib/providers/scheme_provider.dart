import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scheme_model.dart';

class SchemeNotifier extends StateNotifier<AsyncValue<List<SchemeModel>>> {
  SchemeNotifier() : super(const AsyncValue.loading()) {
    loadSchemes();
  }

  List<SchemeModel> _allSchemes = [];
  String _selectedCategory = 'all';
  bool _showBookmarkedOnly = false;
  final Set<String> _bookmarkedIds = {};

  Future<void> loadSchemes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/schemes.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List;
      _allSchemes = jsonList.map((j) => SchemeModel.fromJson(j as Map<String, dynamic>)).toList();
      state = AsyncValue.data(_filteredSchemes());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<SchemeModel> _filteredSchemes() {
    return _allSchemes.where((s) {
      final matchesCat = _selectedCategory == 'all' || s.category == _selectedCategory;
      final matchesBookmark = !_showBookmarkedOnly || _bookmarkedIds.contains(s.id);
      return matchesCat && matchesBookmark;
    }).map((s) => s.copyWith(isBookmarked: _bookmarkedIds.contains(s.id))).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    if (_allSchemes.isNotEmpty) state = AsyncValue.data(_filteredSchemes());
  }

  void toggleBookmarkOnly() {
    _showBookmarkedOnly = !_showBookmarkedOnly;
    if (_allSchemes.isNotEmpty) state = AsyncValue.data(_filteredSchemes());
  }

  void toggleBookmark(String schemeId) {
    if (_bookmarkedIds.contains(schemeId)) {
      _bookmarkedIds.remove(schemeId);
    } else {
      _bookmarkedIds.add(schemeId);
    }
    state = AsyncValue.data(_filteredSchemes());
  }

  bool isBookmarked(String schemeId) => _bookmarkedIds.contains(schemeId);

  List<String> get categories {
    final cats = _allSchemes.map((s) => s.category).toSet().toList();
    cats.sort();
    return ['all', ...cats];
  }
}

final schemeProvider = StateNotifierProvider<SchemeNotifier, AsyncValue<List<SchemeModel>>>((ref) {
  return SchemeNotifier();
});
