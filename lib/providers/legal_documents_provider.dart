import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/legal_document_model.dart';

// State notifier for legal documents
class LegalDocumentsNotifier extends StateNotifier<List<LegalDocument>> {
  LegalDocumentsNotifier() : super([]) {
    _loadDocuments();
  }

  // Load documents from local storage
  Future<void> _loadDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = prefs.getString('legal_documents');
      
      if (documentsJson != null) {
        final List<dynamic> decoded = jsonDecode(documentsJson);
        final documents = decoded
            .map((item) => LegalDocument.fromJson(item as Map<String, dynamic>))
            .toList();
        state = documents;
      }
    } catch (e) {
      print('Error loading documents: $e');
    }
  }

  // Save documents to local storage
  Future<void> _saveDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = jsonEncode(state.map((doc) => doc.toJson()).toList());
      await prefs.setString('legal_documents', documentsJson);
    } catch (e) {
      print('Error saving documents: $e');
    }
  }

  // Add a new document
  void addDocument(LegalDocument document) {
    state = [...state, document];
    _saveDocuments();
  }

  // Remove a document
  void removeDocument(String documentId) {
    state = state.where((doc) => doc.id != documentId).toList();
    _saveDocuments();
  }

  // Update a document
  void updateDocument(LegalDocument document) {
    state = state.map((doc) => doc.id == document.id ? document : doc).toList();
    _saveDocuments();
  }

  // Filter documents by client
  List<LegalDocument> getDocumentsByClient(String clientName) {
    return state.where((doc) => doc.clientName?.toLowerCase().contains(clientName.toLowerCase()) ?? false).toList();
  }

  // Filter documents by case
  List<LegalDocument> getDocumentsByCase(String caseNumber) {
    return state.where((doc) => doc.caseNumber?.toLowerCase().contains(caseNumber.toLowerCase()) ?? false).toList();
  }

  // Filter documents by type
  List<LegalDocument> getDocumentsByType(String fileType) {
    return state.where((doc) => doc.fileType.toLowerCase() == fileType.toLowerCase()).toList();
  }

  // Filter documents by tag
  List<LegalDocument> getDocumentsByTag(String tag) {
    return state.where((doc) => doc.tags.contains(tag)).toList();
  }

  // Search documents
  List<LegalDocument> searchDocuments(String query) {
    final lowerQuery = query.toLowerCase();
    return state.where((doc) =>
        doc.fileName.toLowerCase().contains(lowerQuery) ||
        (doc.clientName?.toLowerCase().contains(lowerQuery) ?? false) ||
        (doc.caseNumber?.toLowerCase().contains(lowerQuery) ?? false) ||
        (doc.description?.toLowerCase().contains(lowerQuery) ?? false)).toList();
  }

  // Clear all documents
  void clearAllDocuments() {
    state = [];
    _saveDocuments();
  }
}

// Provider for legal documents
final legalDocumentsProvider =
    StateNotifierProvider<LegalDocumentsNotifier, List<LegalDocument>>((ref) {
  return LegalDocumentsNotifier();
});

// Provider for getting documents by client
final documentsByClientProvider =
    Provider.family<List<LegalDocument>, String>((ref, clientName) {
  final documents = ref.watch(legalDocumentsProvider);
  return documents
      .where((doc) => doc.clientName?.toLowerCase().contains(clientName.toLowerCase()) ?? false)
      .toList();
});

// Provider for getting documents by case
final documentsByCaseProvider =
    Provider.family<List<LegalDocument>, String>((ref, caseNumber) {
  final documents = ref.watch(legalDocumentsProvider);
  return documents
      .where((doc) => doc.caseNumber?.toLowerCase().contains(caseNumber.toLowerCase()) ?? false)
      .toList();
});

// Provider for getting documents by type
final documentsByTypeProvider =
    Provider.family<List<LegalDocument>, String>((ref, fileType) {
  final documents = ref.watch(legalDocumentsProvider);
  return documents.where((doc) => doc.fileType.toLowerCase() == fileType.toLowerCase()).toList();
});

// Provider for document statistics
final documentStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final documents = ref.watch(legalDocumentsProvider);
  
  final fileTypeCount = <String, int>{};
  var totalSize = 0;
  
  for (final doc in documents) {
    fileTypeCount[doc.fileType] = (fileTypeCount[doc.fileType] ?? 0) + 1;
    totalSize += doc.fileSizeBytes;
  }
  
  return {
    'total': documents.length,
    'byType': fileTypeCount,
    'totalSize': totalSize,
    'recentDocs': documents.length > 0 
        ? documents.sublist(0, (documents.length > 5 ? 5 : documents.length))
        : [],
  };
});

// Provider for searching documents
final searchDocumentsProvider =
    Provider.family<List<LegalDocument>, String>((ref, query) {
  final documents = ref.watch(legalDocumentsProvider);
  if (query.isEmpty) return documents;
  
  final lowerQuery = query.toLowerCase();
  return documents
      .where((doc) =>
          doc.fileName.toLowerCase().contains(lowerQuery) ||
          (doc.clientName?.toLowerCase().contains(lowerQuery) ?? false) ||
          (doc.caseNumber?.toLowerCase().contains(lowerQuery) ?? false) ||
          (doc.description?.toLowerCase().contains(lowerQuery) ?? false))
      .toList();
});
