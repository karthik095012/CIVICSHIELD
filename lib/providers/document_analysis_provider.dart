import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/document_analysis_model.dart';
import '../services/legal_document_analyzer.dart';

// Provider for legal document analyzer service
final legalDocumentAnalyzerProvider =
    Provider((ref) => LegalDocumentAnalyzer());

// State class for document analysis
class DocumentAnalysisState {
  final bool isLoading;
  final DocumentAnalysis? analysis;
  final String? error;
  final String? selectedFilePath;

  DocumentAnalysisState({
    this.isLoading = false,
    this.analysis,
    this.error,
    this.selectedFilePath,
  });

  DocumentAnalysisState copyWith({
    bool? isLoading,
    DocumentAnalysis? analysis,
    String? error,
    String? selectedFilePath,
  }) {
    return DocumentAnalysisState(
      isLoading: isLoading ?? this.isLoading,
      analysis: analysis ?? this.analysis,
      error: error,
      selectedFilePath: selectedFilePath ?? this.selectedFilePath,
    );
  }
}

// Notifier for document analysis
class DocumentAnalysisNotifier extends StateNotifier<DocumentAnalysisState> {
  final Ref ref;

  DocumentAnalysisNotifier(this.ref) : super(DocumentAnalysisState());

  // Pick document from device
  Future<void> pickDocument() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickMedia();

      if (file != null) {
        state = state.copyWith(selectedFilePath: file.path, error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick document: $e');
    }
  }

  // Analyze document using Ollama
  Future<void> analyzeDocument({
    required String filePath,
    required String documentName,
    String documentType = 'text',
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final analyzer = ref.read(legalDocumentAnalyzerProvider);

      // Check if Ollama is available
      final isAvailable = await analyzer.isOllamaAvailable();
      if (!isAvailable) {
        throw Exception(
            'Ollama service is not available. Please ensure Ollama is running on http://localhost:11434');
      }

      // Perform analysis
      final analysis = await analyzer.analyzeDocument(
        documentFile: File(filePath),
        documentName: documentName,
        documentType: documentType,
      );

      state = state.copyWith(
        analysis: analysis,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Analysis failed: $e',
      );
    }
  }

  // Clear analysis
  void clearAnalysis() {
    state = DocumentAnalysisState();
  }

  // Reset state
  void reset() {
    state = DocumentAnalysisState();
  }
}

// Provider for document analysis state
final documentAnalysisProvider =
    StateNotifierProvider<DocumentAnalysisNotifier, DocumentAnalysisState>(
        (ref) {
  return DocumentAnalysisNotifier(ref);
});

// Provider for case analysis predictions
final casePredictionProvider = Provider((ref) {
  final state = ref.watch(documentAnalysisProvider);
  return state.analysis?.casePrediction;
});

// Provider for bias detection results
final biasDetectionProvider = Provider((ref) {
  final state = ref.watch(documentAnalysisProvider);
  return state.analysis?.biasDetection;
});

// Provider for case analysis details
final caseAnalysisProvider = Provider((ref) {
  final state = ref.watch(documentAnalysisProvider);
  return state.analysis?.caseAnalysis;
});

// Provider for document history
final documentHistoryProvider =
    StateNotifierProvider<DocumentHistoryNotifier, List<DocumentAnalysis>>(
        (ref) {
  return DocumentHistoryNotifier();
});

class DocumentHistoryNotifier extends StateNotifier<List<DocumentAnalysis>> {
  DocumentHistoryNotifier() : super([]);

  void addAnalysis(DocumentAnalysis analysis) {
    state = [analysis, ...state].take(10).toList(); // Keep last 10 analyses
  }

  void removeAnalysis(String documentName) {
    state = state.where((a) => a.documentName != documentName).toList();
  }

  void clearHistory() {
    state = [];
  }
}
