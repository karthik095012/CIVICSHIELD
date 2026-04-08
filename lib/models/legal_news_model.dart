class LegalNewsItem {
  final String id;
  final String title;
  final String source;
  final String url;
  final DateTime publishedAt;
  final String summary;

  const LegalNewsItem({
    required this.id,
    required this.title,
    required this.source,
    required this.url,
    required this.publishedAt,
    required this.summary,
  });

  factory LegalNewsItem.fromJson(Map<String, dynamic> json) {
    return LegalNewsItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Untitled update').toString(),
      source: (json['source'] ?? 'Unknown source').toString(),
      url: (json['url'] ?? '').toString(),
      publishedAt: _parseDate(json['publishedAt']),
      summary: (json['summary'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'source': source,
      'url': url,
      'publishedAt': publishedAt.toIso8601String(),
      'summary': summary,
    };
  }

  factory LegalNewsItem.fromGdeltJson(Map<String, dynamic> json, int index) {
    final title = (json['title'] ?? 'Legal update').toString().trim();
    final rawUrl = (json['url'] ?? '').toString().trim();
    final sourceDomain = (json['domain'] ?? '').toString().trim();
    final sourceName = sourceDomain.isNotEmpty
        ? sourceDomain.replaceFirst('www.', '')
        : ((json['sourcecountry'] ?? 'Legal News Feed').toString().trim());
    final seendate = json['seendate'];
    final summary = (json['snippet'] ?? json['description'] ?? '').toString().trim();
    final publishedAt = _parseDate(seendate);

    final fallbackId = '${title}_${publishedAt.millisecondsSinceEpoch}_$index';
    return LegalNewsItem(
      id: rawUrl.isNotEmpty ? rawUrl : fallbackId,
      title: title,
      source: sourceName,
      url: rawUrl,
      publishedAt: publishedAt,
      summary: summary,
    );
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw == null) return DateTime.now();

    final value = raw.toString().trim();
    if (value.isEmpty) return DateTime.now();

    final direct = DateTime.tryParse(value);
    if (direct != null) {
      return direct.toLocal();
    }

    final compact = RegExp(r'^(\d{4})(\d{2})(\d{2})T?(\d{2})?(\d{2})?(\d{2})?Z?$').firstMatch(value);
    if (compact != null) {
      final year = int.tryParse(compact.group(1) ?? '') ?? DateTime.now().year;
      final month = int.tryParse(compact.group(2) ?? '') ?? DateTime.now().month;
      final day = int.tryParse(compact.group(3) ?? '') ?? DateTime.now().day;
      final hour = int.tryParse(compact.group(4) ?? '') ?? 0;
      final minute = int.tryParse(compact.group(5) ?? '') ?? 0;
      final second = int.tryParse(compact.group(6) ?? '') ?? 0;
      return DateTime.utc(year, month, day, hour, minute, second).toLocal();
    }

    return DateTime.now();
  }
}

class LegalNewsSnapshot {
  final List<LegalNewsItem> items;
  final DateTime fetchedAt;
  final String cacheDay;
  final bool fromCache;
  final bool staleCache;

  const LegalNewsSnapshot({
    required this.items,
    required this.fetchedAt,
    required this.cacheDay,
    required this.fromCache,
    required this.staleCache,
  });

  factory LegalNewsSnapshot.empty() {
    return LegalNewsSnapshot(
      items: const [],
      fetchedAt: DateTime.now(),
      cacheDay: '',
      fromCache: false,
      staleCache: false,
    );
  }

  LegalNewsSnapshot copyWith({
    List<LegalNewsItem>? items,
    DateTime? fetchedAt,
    String? cacheDay,
    bool? fromCache,
    bool? staleCache,
  }) {
    return LegalNewsSnapshot(
      items: items ?? this.items,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      cacheDay: cacheDay ?? this.cacheDay,
      fromCache: fromCache ?? this.fromCache,
      staleCache: staleCache ?? this.staleCache,
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'fetchedAt': fetchedAt.toIso8601String(),
      'cacheDay': cacheDay,
    };
  }

  factory LegalNewsSnapshot.fromCacheJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? const []);
    final parsedItems = rawItems
        .whereType<Map<String, dynamic>>()
        .map(LegalNewsItem.fromJson)
        .toList();

    return LegalNewsSnapshot(
      items: parsedItems,
      fetchedAt: DateTime.tryParse((json['fetchedAt'] ?? '').toString())?.toLocal() ?? DateTime.now(),
      cacheDay: (json['cacheDay'] ?? '').toString(),
      fromCache: true,
      staleCache: false,
    );
  }
}