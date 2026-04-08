import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rights_card_model.dart';

class RightsNotifier extends StateNotifier<AsyncValue<List<RightsCardModel>>> {
  RightsNotifier() : super(const AsyncValue.loading()) {
    loadRightsCards();
  }

  List<RightsCardModel> _allCards = [];
  String _selectedCategory = 'all';

  Future<void> loadRightsCards() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/rights_cards.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List;
      _allCards = jsonList.map((j) => RightsCardModel.fromJson(j as Map<String, dynamic>)).toList();
      state = AsyncValue.data(_filteredCards());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<RightsCardModel> _filteredCards() {
    if (_selectedCategory == 'all') return _allCards;
    return _allCards.where((c) => c.category == _selectedCategory).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    if (_allCards.isNotEmpty) {
      state = AsyncValue.data(_filteredCards());
    }
  }

  List<String> get categories {
    return _allCards.map((c) => c.category).toSet().toList();
  }
}

final rightsProvider = StateNotifierProvider<RightsNotifier, AsyncValue<List<RightsCardModel>>>((ref) {
  return RightsNotifier();
});
