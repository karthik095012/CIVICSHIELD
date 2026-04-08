import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/legal_news_model.dart';

class LegalNewsService {
  static const _cachePayloadKey = 'legal_news_cache_payload_v1';

  Future<LegalNewsSnapshot> loadDailyNews({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = _readCache(prefs);
    final todayKey = _dateKey(DateTime.now().toUtc());

    if (!forceRefresh && cached != null && cached.cacheDay == todayKey) {
      return cached.copyWith(fromCache: true, staleCache: false);
    }

    try {
      final freshItems = await fetchLatestNews();
      if (freshItems.isNotEmpty) {
        final snapshot = LegalNewsSnapshot(
          items: freshItems,
          fetchedAt: DateTime.now(),
          cacheDay: todayKey,
          fromCache: false,
          staleCache: false,
        );
        await _writeCache(prefs, snapshot);
        return snapshot;
      }
    } catch (_) {
      // Falls back to cached data when network fetch fails.
    }

    if (cached != null) {
      return cached.copyWith(fromCache: true, staleCache: true);
    }

    return LegalNewsSnapshot.empty();
  }

  Future<List<LegalNewsItem>> fetchLatestNews() async {
    final uri = Uri.https(
      'api.gdeltproject.org',
      '/api/v2/doc/doc',
      {
        'query': '(India OR Parliament OR "Supreme Court") AND (bill OR law OR legislation OR ordinance OR gazette)',
        'mode': 'ArtList',
        'format': 'json',
        'maxrecords': '50',
        'sort': 'DateDesc',
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('News request failed with status ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected news payload format');
    }

    final rawArticles = decoded['articles'];
    if (rawArticles is! List) {
      return const [];
    }

    final seenKeys = <String>{};
    final items = <LegalNewsItem>[];

    for (var i = 0; i < rawArticles.length; i++) {
      final raw = rawArticles[i];
      if (raw is! Map<String, dynamic>) {
        continue;
      }

      final item = LegalNewsItem.fromGdeltJson(raw, i);
      if (item.title.isEmpty || item.url.isEmpty) {
        continue;
      }

      if (!_looksLikeLegalUpdate(item.title)) {
        continue;
      }

      final dedupeKey = item.url.toLowerCase();
      if (!seenKeys.add(dedupeKey)) {
        continue;
      }

      items.add(item);
      if (items.length >= 25) {
        break;
      }
    }

    items.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return items;
  }

  bool _looksLikeLegalUpdate(String title) {
    final lower = title.toLowerCase();
    const keywords = [
      'bill',
      'bills',
      'law',
      'laws',
      'act',
      'legislation',
      'ordinance',
      'gazette',
      'parliament',
      'lok sabha',
      'rajya sabha',
      'supreme court',
      'ministry of law',
    ];
    return keywords.any(lower.contains);
  }

  LegalNewsSnapshot? _readCache(SharedPreferences prefs) {
    final raw = prefs.getString(_cachePayloadKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return LegalNewsSnapshot.fromCacheJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(SharedPreferences prefs, LegalNewsSnapshot snapshot) async {
    await prefs.setString(_cachePayloadKey, jsonEncode(snapshot.toCacheJson()));
  }

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}