import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OllamaService {
  static const String _savedBaseUrlKey = 'ollama_base_url';
  static const String _model = 'neural-chat:latest';

  static const List<String> _androidCandidates = [
    'http://10.0.2.2:11434',
    'http://localhost:11434',
    'http://127.0.0.1:11434',
  ];
  
  static final OllamaService _instance = OllamaService._internal();
  
  factory OllamaService() {
    return _instance;
  }
  
  OllamaService._internal();

  String _defaultBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:11434';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emulator maps host machine localhost to 10.0.2.2.
      return 'http://10.0.2.2:11434';
    }
    return 'http://localhost:11434';
  }

  String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return _defaultBaseUrl();
    }

    final withScheme = trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : 'http://$trimmed';

    return withScheme.endsWith('/')
        ? withScheme.substring(0, withScheme.length - 1)
        : withScheme;
  }

  Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_savedBaseUrlKey);
    if (saved == null || saved.isEmpty) {
      return _defaultBaseUrl();
    }
    return _normalizeBaseUrl(saved);
  }

  Future<void> setBaseUrl(String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedBaseUrlKey, _normalizeBaseUrl(baseUrl));
  }

  Future<String?> autoDetectReachableBaseUrl() async {
    final current = await getBaseUrl();
    final candidates = <String>[current];

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      candidates.addAll(_androidCandidates);
    }
    candidates.add(_defaultBaseUrl());

    final seen = <String>{};
    for (final candidate in candidates) {
      final normalized = _normalizeBaseUrl(candidate);
      if (!seen.add(normalized)) {
        continue;
      }

      final ok = await checkConnection(overrideBaseUrl: normalized);
      if (ok) {
        await setBaseUrl(normalized);
        return normalized;
      }
    }

    return null;
  }

  Future<bool> checkConnection({String? overrideBaseUrl}) async {
    final baseUrl = overrideBaseUrl == null
        ? await getBaseUrl()
        : _normalizeBaseUrl(overrideBaseUrl);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tags'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Stream<String> askLegalQuestion(String question) async* {
    final baseUrl = await getBaseUrl();

    try {
      const systemPrompt = '''You are an expert legal advisor specializing in Indian traffic laws, citizens' rights, and legal procedures. 
You provide clear, practical legal guidance in a friendly manner. Always:
1. Give accurate legal information based on Indian law
2. Advise when professional legal consultation is needed
3. Be concise and easy to understand
4. Explain legal terms simply
5. Mention relevant laws/acts when applicable

Answer the following question about legal matters:''';

      final prompt = '$systemPrompt\n\nQuestion: $question\n\nAnswer:';

      final response = await http.post(
        Uri.parse('$baseUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'prompt': prompt,
          'stream': true,
          'temperature': 0.7,
        }),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode != 200) {
        yield 'Error: Unable to process your question. Please try again.';
        return;
      }

      final String responseBody = response.body;
      final List<String> lines = responseBody.split('\n');

      for (final String line in lines) {
        if (line.trim().isEmpty) continue;
        
        try {
          final Map<String, dynamic> json = jsonDecode(line);
          if (json['response'] != null) {
            yield json['response'] as String;
          }
          if (json['done'] == true) {
            break;
          }
        } catch (e) {
          // Handle JSON parsing error
          continue;
        }
      }
    } catch (e) {
      yield 'Error: Unable to reach Ollama server at $baseUrl';
    }
  }

  Future<String> getFullResponse(String question) async {
    final buffer = StringBuffer();
    await for (final chunk in askLegalQuestion(question)) {
      buffer.write(chunk);
    }
    return buffer.toString();
  }
}
