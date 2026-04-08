import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/document_analysis_model.dart';

class LegalDocumentAnalyzer {
  static const String _ollamaBaseUrl = 'http://localhost:11434';
  static const String _defaultModel = 'llama2:latest';
  
  final String ollamaUrl;
  final String modelName;

  LegalDocumentAnalyzer({
    this.ollamaUrl = _ollamaBaseUrl,
    this.modelName = _defaultModel,
  });

  // Check if Ollama is available
  Future<bool> isOllamaAvailable() async {
    try {
      final response = await http
          .get(Uri.parse('$ollamaUrl/api/tags'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('⚠️ Ollama connection failed: $e');
      return false;
    }
  }

  // Analyze uploaded document (PDF/Text)
  Future<DocumentAnalysis> analyzeDocument({
    required File documentFile,
    required String documentName,
    required String documentType, // 'pdf', 'text', 'image'
  }) async {
    try {
      // Extract text from document
      String extractedText =
          await _extractTextFromDocument(documentFile, documentType);

      // Perform multi-level analysis
      final caseAnalysis = await _analyzeCaseDetails(extractedText);
      final casePrediction = await _predictCaseOutcome(extractedText);
      final biasDetection = await _detectBiasInDecision(extractedText);

      return DocumentAnalysis(
        documentName: documentName,
        uploadedAt: DateTime.now().toIso8601String(),
        documentType: documentType,
        content: extractedText,
        caseAnalysis: caseAnalysis,
        casePrediction: casePrediction,
        biasDetection: biasDetection,
      );
    } catch (e) {
      print('❌ Document analysis failed: $e');
      rethrow;
    }
  }

  // Extract text from document
  Future<String> _extractTextFromDocument(
      File file, String documentType) async {
    try {
      if (documentType == 'text') {
        return await file.readAsString();
      } else if (documentType == 'pdf') {
        // For PDF, we would use a PDF extraction library
        // For now, return placeholder
        return "PDF content extraction pending - use pdf library";
      } else if (documentType == 'image') {
        // For images, use OCR via Ollama
        return await _performOCR(file);
      }
      return '';
    } catch (e) {
      print('❌ Text extraction failed: $e');
      return '';
    }
  }

  // Perform OCR on image using Ollama
  Future<String> _performOCR(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final prompt =
          'Extract all text from this legal document image. Return only the extracted text:';

      final response = await http.post(
        Uri.parse('$ollamaUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': modelName,
          'prompt': prompt,
          'images': [base64Image],
          'stream': false,
          'temperature': 0.3,
        }),
      ).timeout(const Duration(minutes: 2));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? '';
      }
      return '';
    } catch (e) {
      print('❌ OCR failed: $e');
      return '';
    }
  }

  // Analyze case details from document
  Future<CaseAnalysis> _analyzeCaseDetails(String documentContent) async {
    try {
      const prompt =
          '''Analyze this legal case document and provide:
1. A brief summary (2-3 sentences)
2. Key points (list 3-5 important points)
3. Applicable laws and statutes
4. Relevant legal precedents
5. Case strengths
6. Case weaknesses

Document:
''';

      final response = await _callOllama(prompt + documentContent);

      // Parse response to extract structured data
      final lines = response.split('\n');
      final analysis = CaseAnalysis(
        summary: _extractSection(response, 'summary|Summary'),
        keyPoints: _extractList(response, 'key points|Key Points'),
        applicableLaws: _extractSection(response, 'applicable laws|laws|Applicable Laws'),
        precedents: _extractSection(response, 'precedents|Precedents'),
        strengths: _extractSection(response, 'strengths|Strengths'),
        weaknesses: _extractSection(response, 'weaknesses|Weaknesses'),
      );

      return analysis;
    } catch (e) {
      print('❌ Case analysis failed: $e');
      return CaseAnalysis(
        summary: 'Analysis pending',
        keyPoints: [],
        applicableLaws: '',
        precedents: '',
        strengths: '',
        weaknesses: '',
      );
    }
  }

  // Predict case outcome using ML-like analysis
  Future<CasePrediction> _predictCaseOutcome(String documentContent) async {
    try {
      const prompt =
          '''Based on this legal case document, predict:
1. The likely case outcome (Favorable/Unfavorable/Uncertain)
2. Success probability (0-100%)
3. Key factors influencing the outcome
4. Recommendations for strengthening the case
5. Explainability: Why do you predict this outcome?

Document:
''';

      final response = await _callOllama(prompt + documentContent);

      return CasePrediction(
        outcomePredictor: _extractSection(response, 'outcome|Outcome'),
        successProbability: _extractPercentage(response),
        recommendation:
            _extractSection(response, 'recommendation|Recommendations'),
        factors: _extractList(response, 'factors|Factors'),
        explainability: _extractSection(response, 'explainability|Explainability'),
      );
    } catch (e) {
      print('❌ Prediction failed: $e');
      return CasePrediction(
        outcomePredictor: 'Analysis pending',
        successProbability: 0,
        recommendation: '',
        factors: [],
        explainability: '',
      );
    }
  }

  // Detect bias in judicial decisions
  Future<BiasDetection> _detectBiasInDecision(String documentContent) async {
    try {
      const prompt =
          '''Analyze this legal case document for potential bias in judicial decisions:
1. Are there signs of bias? (Yes/No)
2. Identify bias indicators (gender, caste, socioeconomic, regional, etc.)
3. Risk level assessment (Low/Medium/High)
4. Fairness score (0-100)
5. Recommendations to counter identified biases

Look for:
- Language that favors one party
- Inconsistent application of laws
- Stereotypes or prejudicial language
- Deviation from standard legal procedures
- Disproportionate judgments

Document:
''';

      final response = await _callOllama(prompt + documentContent);

      final biasDetected =
          response.toLowerCase().contains('yes') || response.toLowerCase().contains('bias detected');

      return BiasDetection(
        biasDetected: biasDetected,
        indicators: _extractBiasIndicators(response),
        riskLevel: _extractRiskLevel(response),
        recommendations: _extractSection(response, 'recommendation|Recommendations'),
        fairnessScore: _extractSection(response, 'fairness score|Fairness Score'),
      );
    } catch (e) {
      print('❌ Bias detection failed: $e');
      return BiasDetection(
        biasDetected: false,
        indicators: [],
        riskLevel: 'low',
        recommendations: '',
        fairnessScore: '',
      );
    }
  }

  // Call Ollama API
  Future<String> _callOllama(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$ollamaUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': modelName,
          'prompt': prompt,
          'stream': false,
          'temperature': 0.5,
        }),
      ).timeout(const Duration(minutes: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? '';
      }
      throw Exception('Ollama API error: ${response.statusCode}');
    } catch (e) {
      print('❌ Ollama API call failed: $e');
      rethrow;
    }
  }

  // Helper methods to extract structured data from Ollama response
  String _extractSection(String text, String pattern) {
    try {
      final regex = RegExp(pattern, caseSensitive: false);
      final match = regex.firstMatch(text);
      if (match != null) {
        final start = match.end;
        final endPattern = RegExp(r'\d+\.|next section|Analysis|Summary');
        final endMatch = endPattern.firstMatch(text.substring(start));
        if (endMatch != null) {
          return text.substring(start, start + endMatch.start).trim();
        }
        return text.substring(start).trim();
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  List<String> _extractList(String text, String pattern) {
    final items = <String>[];
    try {
      final regex = RegExp(pattern, caseSensitive: false);
      final match = regex.firstMatch(text);
      if (match != null) {
        final section = text.substring(match.end);
        final listItems = section.split(RegExp(r'\n[0-9]+\.|•|-|\n'));
        items.addAll(listItems
            .where((item) => item.isNotEmpty)
            .map((item) => item.trim())
            .take(5));
      }
    } catch (e) {
      print('List extraction error: $e');
    }
    return items;
  }

  int _extractPercentage(String text) {
    try {
      final regex = RegExp(r'(\d+)%');
      final match = regex.firstMatch(text);
      if (match != null) {
        return int.parse(match.group(1) ?? '0');
      }
    } catch (e) {
      print('Percentage extraction error: $e');
    }
    return 50; // Default to 50% if not found
  }

  String _extractRiskLevel(String text) {
    if (text.toLowerCase().contains('high')) return 'high';
    if (text.toLowerCase().contains('medium')) return 'medium';
    return 'low';
  }

  List<BiasIndicator> _extractBiasIndicators(String text) {
    final indicators = <BiasIndicator>[];
    final biasTypes = [
      'gender',
      'caste',
      'socioeconomic',
      'regional',
      'religious',
      'language'
    ];

    for (final type in biasTypes) {
      if (text.toLowerCase().contains(type)) {
        indicators.add(BiasIndicator(
          type: type,
          description: 'Potential $type bias detected in judicial language',
          severity: text.toLowerCase().contains('high $type') ? 'high' : 'medium',
        ));
      }
    }

    return indicators;
  }
}
