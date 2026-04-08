import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/complaint_summary_model.dart';

final complaintSummariesProvider = StateNotifierProvider<ComplaintSummariesNotifier, List<ComplaintSummary>>((ref) {
  return ComplaintSummariesNotifier();
});

final complaintSummaryByIdProvider = FutureProvider.family<ComplaintSummary?, String>((ref, id) async {
  final summaries = ref.watch(complaintSummariesProvider);
  return summaries.firstWhere((s) => s.id == id, orElse: () => throw Exception('Not found'));
});

class ComplaintSummariesNotifier extends StateNotifier<List<ComplaintSummary>> {
  ComplaintSummariesNotifier() : super([]);

  void addSummary(ComplaintSummary summary) {
    state = [...state, summary];
  }

  void updateSummary(ComplaintSummary summary) {
    state = [
      for (final s in state)
        if (s.id == summary.id) summary else s,
    ];
  }

  void removeSummary(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  void markAsExported(String id) {
    state = [
      for (final s in state)
        if (s.id == id)
          ComplaintSummary(
            id: s.id,
            incidentReportId: s.incidentReportId,
            title: s.title,
            description: s.description,
            issueType: s.issueType,
            violationCategory: s.violationCategory,
            amountInvolved: s.amountInvolved,
            location: s.location,
            incidentDate: s.incidentDate,
            authorityInvolved: s.authorityInvolved,
            evidence: s.evidence,
            severity: s.severity,
            status: s.status,
            recommendedActions: s.recommendedActions,
            createdAt: s.createdAt,
            exportedAt: DateTime.now(),
          )
        else
          s,
    ];
  }

  Future<void> loadFromStorage() async {
    // TODO: Load from local storage (Hive)
    // This is a placeholder
  }

  Future<void> saveToStorage() async {
    // TODO: Save to local storage (Hive)
    // This is a placeholder
  }
}
