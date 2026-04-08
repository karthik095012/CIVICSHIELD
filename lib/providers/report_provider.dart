import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/incident_report_model.dart';

class ReportNotifier extends StateNotifier<List<IncidentReportModel>> {
  ReportNotifier() : super([]) {
    _loadReports();
  }

  static const String _storageKey = 'civicshield_incident_reports';

  Future<void> _loadReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString) as List;
        state = jsonList
            .map((j) => IncidentReportModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
  }

  Future<void> _saveReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(state.map((r) => r.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {}
  }

  Future<void> addReport(IncidentReportModel report) async {
    state = [report, ...state];
    await _saveReports();
  }

  Future<void> updateReport(IncidentReportModel updated) async {
    state = state.map((r) => r.id == updated.id ? updated : r).toList();
    await _saveReports();
  }

  Future<void> deleteReport(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _saveReports();
  }

  String generateAISummary(IncidentReportModel report) {
    final sb = StringBuffer();
    sb.writeln('CIVIC INCIDENT REPORT');
    sb.writeln('=====================');
    sb.writeln('Date & Time: ${report.formattedDate}');
    sb.writeln('Location: ${report.locationName}');
    sb.writeln('Issue Type: ${report.issueTypeDisplay}');
    sb.writeln('Violation Category: ${report.violationCategory}');
    if (report.amountAsked != null) {
      sb.writeln('Amount Demanded: ₹${report.amountAsked!.toStringAsFixed(0)}');
    }
    if (report.amountPaid != null) {
      sb.writeln('Amount Paid: ₹${report.amountPaid!.toStringAsFixed(0)}');
    }
    sb.writeln('Official Receipt Given: ${report.receiptGiven ? "Yes" : "No"}');
    sb.writeln('');
    sb.writeln('INCIDENT DESCRIPTION:');
    sb.writeln(report.notes);
    sb.writeln('');
    sb.writeln('RECOMMENDED NEXT STEPS:');
    if (!report.receiptGiven) {
      sb.writeln('• Report the lack of receipt to the Anti-Corruption Bureau');
      sb.writeln('• Contact: ACB Karnataka — 1064 / acb.karnataka.gov.in');
    }
    if (report.issueType == 'bribe_request') {
      sb.writeln('• File complaint immediately at Anti-Corruption Bureau');
      sb.writeln('• Keep all evidence safe — do not share publicly yet');
    }
    sb.writeln('• Submit this report to the official grievance portal');
    sb.writeln('• Follow up in 7 days if no acknowledgment received');
    sb.writeln('');
    sb.writeln('DISCLAIMER: This report is for awareness and civic documentation purposes. Consult a legal professional for specific legal advice.');
    return sb.toString();
  }
}

final reportProvider = StateNotifierProvider<ReportNotifier, List<IncidentReportModel>>((ref) {
  return ReportNotifier();
});
