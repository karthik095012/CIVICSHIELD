import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/legal_news_model.dart';
import '../services/legal_news_service.dart';

final legalNewsProvider = StateNotifierProvider<LegalNewsNotifier, LegalNewsState>((ref) {
  return LegalNewsNotifier();
});

class LegalNewsState {
  final List<LegalNewsItem> items;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final DateTime? lastUpdated;
  final bool fromCache;
  final bool staleCache;

  const LegalNewsState({
    required this.items,
    required this.isLoading,
    required this.isRefreshing,
    required this.error,
    required this.lastUpdated,
    required this.fromCache,
    required this.staleCache,
  });

  factory LegalNewsState.initial() {
    return const LegalNewsState(
      items: [],
      isLoading: true,
      isRefreshing: false,
      error: null,
      lastUpdated: null,
      fromCache: false,
      staleCache: false,
    );
  }

  LegalNewsState copyWith({
    List<LegalNewsItem>? items,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    DateTime? lastUpdated,
    bool? fromCache,
    bool? staleCache,
  }) {
    return LegalNewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      lastUpdated: lastUpdated ?? this.lastUpdated,
      fromCache: fromCache ?? this.fromCache,
      staleCache: staleCache ?? this.staleCache,
    );
  }
}

class LegalNewsNotifier extends StateNotifier<LegalNewsState> {
  final LegalNewsService _service = LegalNewsService();

  LegalNewsNotifier() : super(LegalNewsState.initial()) {
    loadNews();
  }

  Future<void> loadNews({bool forceRefresh = false}) async {
    final hasData = state.items.isNotEmpty;
    state = state.copyWith(
      isLoading: !hasData,
      isRefreshing: hasData,
      clearError: true,
    );

    try {
      final snapshot = await _service.loadDailyNews(forceRefresh: forceRefresh);

      if (snapshot.items.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: 'No legal updates available right now. Please try again later.',
          lastUpdated: snapshot.fetchedAt,
          fromCache: snapshot.fromCache,
          staleCache: snapshot.staleCache,
        );
        return;
      }

      state = state.copyWith(
        items: snapshot.items,
        isLoading: false,
        isRefreshing: false,
        clearError: true,
        lastUpdated: snapshot.fetchedAt,
        fromCache: snapshot.fromCache,
        staleCache: snapshot.staleCache,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: 'Unable to load updates. Pull to refresh and try again.',
      );
    }
  }

  Future<void> refreshNow() async {
    await loadNews(forceRefresh: true);
  }
}