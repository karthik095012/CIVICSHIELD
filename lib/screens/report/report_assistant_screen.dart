import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme.dart';
import '../../models/incident_report_model.dart';
import '../../providers/report_provider.dart';

class ReportAssistantScreen extends ConsumerStatefulWidget {
  const ReportAssistantScreen({super.key});

  @override
  ConsumerState<ReportAssistantScreen> createState() => _ReportAssistantScreenState();
}

class _ReportAssistantScreenState extends ConsumerState<ReportAssistantScreen> {
  int _currentStep = 0;
  final int _totalSteps = 6;

  String _issueType = '';
  String _violationCategory = '';
  double? _amountAsked;
  double? _amountPaid;
  bool _receiptGiven = false;
  String _locationName = 'Bengaluru, Karnataka';
  String _notes = '';
  bool _isAnonymous = true;
  bool _submitted = false;
  String? _aiSummary;
  final ImagePicker _imagePicker = ImagePicker();
  final List<_ProofPhoto> _proofPhotos = [];

  final _amountAskedController = TextEditingController();
  final _amountPaidController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = _locationName;
  }

  @override
  void dispose() {
    _amountAskedController.dispose();
    _amountPaidController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        title: const Text('File Case'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: CivicShieldTheme.borderGlow),
        ),
      ),
      body: _submitted ? _buildSuccessScreen() : _buildFormScreen(),
    );
  }

  Widget _buildFormScreen() {
    return Column(
      children: [
        _buildStepIndicator(),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: SingleChildScrollView(
              key: ValueKey(_currentStep),
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStep(),
            ),
          ),
        ),
        _buildNavButtons(),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        border: Border(bottom: BorderSide(color: CivicShieldTheme.borderGlow)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: const TextStyle(color: CivicShieldTheme.accentCyan, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).toInt()}% complete',
                style: const TextStyle(color: CivicShieldTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: CivicShieldTheme.borderGlow,
              valueColor: const AlwaysStoppedAnimation<Color>(CivicShieldTheme.accentCyan),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildIssueTypeStep();
      case 1: return _buildViolationCategoryStep();
      case 2: return _buildAmountsStep();
      case 3: return _buildLocationStep();
      case 4: return _buildNotesStep();
      case 5: return _buildReviewStep();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildIssueTypeStep() {
    final issues = [
      ('overcharging', 'Overcharging', Icons.money_off_rounded, CivicShieldTheme.dangerRed),
      ('no_receipt', 'No Receipt Issued', Icons.receipt_long_rounded, CivicShieldTheme.warningOrange),
      ('bribe_request', 'Bribe Request', Icons.warning_amber_rounded, const Color(0xFF9B59B6)),
      ('wrong_fine', 'Wrong Fine Applied', Icons.gavel_rounded, CivicShieldTheme.infoBlue),
      ('harassment', 'Harassment / Intimidation', Icons.person_off_rounded, CivicShieldTheme.dangerRed),
      ('misleading', 'Misleading Information', Icons.info_rounded, CivicShieldTheme.warningOrange),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('What happened?', 'Select the type of issue you experienced'),
        const SizedBox(height: 16),
        ...issues.map((item) {
          final (key, label, icon, color) = item;
          final isSelected = _issueType == key;
          return GestureDetector(
            onTap: () => setState(() => _issueType = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : CivicShieldTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : CivicShieldTheme.borderGlow,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: isSelected ? color : CivicShieldTheme.textMuted, size: 22),
                  const SizedBox(width: 14),
                  Text(label,
                      style: TextStyle(
                        color: isSelected ? CivicShieldTheme.textPrimary : CivicShieldTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      )),
                  const Spacer(),
                  if (isSelected) Icon(Icons.check_circle_rounded, color: color, size: 20),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildViolationCategoryStep() {
    final categories = ['Traffic', 'Parking', 'Consumer', 'Healthcare', 'Municipal', 'Property', 'Other'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Violation Category', 'Which type of violation was involved?'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((cat) {
            final isSelected = _violationCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _violationCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? CivicShieldTheme.accentCyan.withOpacity(0.15) : CivicShieldTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? CivicShieldTheme.accentCyan : CivicShieldTheme.borderGlow,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(cat,
                    style: TextStyle(
                      color: isSelected ? CivicShieldTheme.accentCyan : CivicShieldTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Money Details', 'How much was asked / paid?'),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _amountAskedController,
          label: 'Amount Demanded (₹)',
          hint: '0',
          keyboardType: TextInputType.number,
          onChanged: (v) => _amountAsked = double.tryParse(v),
          icon: Icons.currency_rupee_rounded,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _amountPaidController,
          label: 'Amount Paid (₹)',
          hint: '0 (leave blank if nothing paid)',
          keyboardType: TextInputType.number,
          onChanged: (v) => _amountPaid = double.tryParse(v),
          icon: Icons.currency_rupee_rounded,
        ),
        const SizedBox(height: 20),
        const Text('Was an official receipt/challan issued?',
            style: TextStyle(color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        Row(
          children: [
            _ReceiptButton(
              label: 'Yes, received',
              icon: Icons.check_circle_rounded,
              isSelected: _receiptGiven,
              color: CivicShieldTheme.successGreen,
              onTap: () => setState(() => _receiptGiven = true),
            ),
            const SizedBox(width: 10),
            _ReceiptButton(
              label: 'No receipt',
              icon: Icons.cancel_rounded,
              isSelected: !_receiptGiven,
              color: CivicShieldTheme.dangerRed,
              onTap: () => setState(() => _receiptGiven = false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Location & Time', 'Where did this happen?'),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _locationController,
          label: 'Location Name',
          hint: 'e.g. Silk Board Junction, Bengaluru',
          onChanged: (v) => _locationName = v,
          icon: Icons.location_on_rounded,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CivicShieldTheme.surfaceCardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CivicShieldTheme.borderGlow),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded, color: CivicShieldTheme.accentCyan, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date & Time', style: TextStyle(color: CivicShieldTheme.textMuted, fontSize: 11)),
                  Text(
                    'Now — ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const TextStyle(color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Switch(
              value: _isAnonymous,
              onChanged: (v) => setState(() => _isAnonymous = v),
              activeThumbColor: CivicShieldTheme.accentCyan,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stay Anonymous', style: TextStyle(color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('Your identity will not be shared publicly', style: TextStyle(color: CivicShieldTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Describe the Incident', 'In your own words, what happened?'),
        const SizedBox(height: 20),
        TextField(
          controller: _notesController,
          maxLines: 7,
          style: const TextStyle(color: CivicShieldTheme.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Describe what happened. Include: what was said, how much was demanded, officer details if available...',
            hintStyle: const TextStyle(color: CivicShieldTheme.textMuted, fontSize: 13),
            filled: true,
            fillColor: CivicShieldTheme.surfaceCardLight,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: CivicShieldTheme.borderGlow)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: CivicShieldTheme.borderGlow)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: CivicShieldTheme.accentCyan, width: 2)),
          ),
          onChanged: (v) => _notes = v,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CivicShieldTheme.infoBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: CivicShieldTheme.infoBlue.withOpacity(0.3)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 16, color: CivicShieldTheme.infoBlue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI will generate a professional complaint summary from your notes after submission.',
                  style: TextStyle(color: CivicShieldTheme.infoBlue, fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Photo Proof (Optional)',
          style: TextStyle(color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickProofPhoto,
          icon: const Icon(Icons.upload_file_rounded, size: 18),
          label: const Text('Upload Photo for Proof'),
          style: OutlinedButton.styleFrom(
            foregroundColor: CivicShieldTheme.accentCyan,
            side: const BorderSide(color: CivicShieldTheme.accentCyan),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_proofPhotos.isNotEmpty) ...[
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _proofPhotos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final photo = _proofPhotos[index];
              return Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        photo.bytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeProofPhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            '${_proofPhotos.length} photo(s) attached as evidence',
            style: const TextStyle(color: CivicShieldTheme.textMuted, fontSize: 11),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Review & Submit', 'Verify your incident report'),
        const SizedBox(height: 16),
        _ReviewRow('Issue Type', _issueType.isEmpty ? 'Not selected' : _issueType.replaceAll('_', ' ').toUpperCase()),
        _ReviewRow('Category', _violationCategory.isEmpty ? 'Not selected' : _violationCategory),
        if (_amountAsked != null) _ReviewRow('Amount Demanded', '₹${_amountAsked!.toStringAsFixed(0)}'),
        if (_amountPaid != null) _ReviewRow('Amount Paid', '₹${_amountPaid!.toStringAsFixed(0)}'),
        _ReviewRow('Receipt Given', _receiptGiven ? 'Yes' : 'No'),
        _ReviewRow('Location', _locationName),
        _ReviewRow('Anonymous', _isAnonymous ? 'Yes' : 'No'),
        _ReviewRow('Photo Proof', _proofPhotos.isEmpty ? 'Not attached' : '${_proofPhotos.length} attached'),
        if (_proofPhotos.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CivicShieldTheme.surfaceCardLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CivicShieldTheme.borderGlow),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _proofPhotos.map((p) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: CivicShieldTheme.accentCyan.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _fileNameFromPath(p.path),
                    style: const TextStyle(fontSize: 11, color: CivicShieldTheme.accentCyan, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        if (_notes.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CivicShieldTheme.surfaceCardLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CivicShieldTheme.borderGlow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Notes', style: TextStyle(color: CivicShieldTheme.accentCyan, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(_notes, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildDisclaimerBox(),
      ],
    );
  }

  Widget _buildDisclaimerBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CivicShieldTheme.warningOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CivicShieldTheme.warningOrange.withOpacity(0.3)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: CivicShieldTheme.warningOrange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'This report will be saved locally. CivicShield does not guarantee government action. For serious crimes, please contact police directly.',
              style: TextStyle(color: CivicShieldTheme.warningOrange, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      decoration: const BoxDecoration(
        color: CivicShieldTheme.surfaceCard,
        border: Border(top: BorderSide(color: CivicShieldTheme.borderGlow)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CivicShieldTheme.textSecondary,
                  side: const BorderSide(color: CivicShieldTheme.borderGlow),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _currentStep < _totalSteps - 1 ? _nextStep : _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: CivicShieldTheme.accentCyan,
                foregroundColor: CivicShieldTheme.textOnAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentStep < _totalSteps - 1 ? 'Continue' : 'Submit Report',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CivicShieldTheme.successGreen.withOpacity(0.15),
                border: Border.all(color: CivicShieldTheme.successGreen, width: 2),
              ),
              child: const Icon(Icons.check_rounded, color: CivicShieldTheme.successGreen, size: 48),
            ),
            const SizedBox(height: 24),
            const Text('Report Submitted!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: CivicShieldTheme.textPrimary)),
            const SizedBox(height: 10),
            const Text(
              'Your incident report has been saved to your Evidence Vault. Use it for future escalation.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 14, height: 1.5),
            ),
            if (_proofPhotos.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: CivicShieldTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CivicShieldTheme.successGreen.withOpacity(0.35)),
                ),
                child: Text(
                  '${_proofPhotos.length} proof photo(s) attached to this report.',
                  style: const TextStyle(color: CivicShieldTheme.successGreen, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_aiSummary != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CivicShieldTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: CivicShieldTheme.borderGlow),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: CivicShieldTheme.accentCyan, size: 16),
                        SizedBox(width: 6),
                        Text('AI Generated Summary', style: TextStyle(color: CivicShieldTheme.accentCyan, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(_aiSummary!, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 11, fontFamily: 'monospace', height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() { _submitted = false; _currentStep = 0; _resetForm(); }),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New Report'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CivicShieldTheme.textSecondary,
                      side: const BorderSide(color: CivicShieldTheme.borderGlow),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/vault'),
                    icon: const Icon(Icons.lock_rounded, size: 18),
                    label: const Text('View Vault'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CivicShieldTheme.accentCyan,
                      foregroundColor: CivicShieldTheme.textOnAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1976D2), width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_rounded, color: Color(0xFF1976D2), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your complaint will be sent to relevant government authorities for official investigation',
                      style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchGovernmentComplaintPage,
                icon: const Icon(Icons.verified_user_rounded, size: 18),
                label: const Text('Report to Authorities'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CivicShieldTheme.textPrimary)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 13, color: CivicShieldTheme.textMuted)),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Function(String) onChanged,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: CivicShieldTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: CivicShieldTheme.textPrimary),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: CivicShieldTheme.textMuted, size: 20),
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  Future<void> _submitReport() async {
    final report = IncidentReportModel(
      issueType: _issueType.isEmpty ? 'other' : _issueType,
      violationCategory: _violationCategory.isEmpty ? 'Other' : _violationCategory,
      amountAsked: _amountAsked,
      amountPaid: _amountPaid,
      receiptGiven: _receiptGiven,
      locationName: _locationName,
      notes: _notes,
      mediaUrls: _proofPhotos.map((p) => p.path).toList(),
      isAnonymous: _isAnonymous,
    );

    final notifier = ref.read(reportProvider.notifier);
    final summary = notifier.generateAISummary(report);
    final finalReport = report.copyWith(aiSummary: summary);
    await notifier.addReport(finalReport);

    setState(() {
      _submitted = true;
      _aiSummary = summary;
    });
  }

  void _resetForm() {
    _issueType = '';
    _violationCategory = '';
    _amountAsked = null;
    _amountPaid = null;
    _receiptGiven = false;
    _locationName = 'Bengaluru, Karnataka';
    _notes = '';
    _isAnonymous = true;
    _aiSummary = null;
    _proofPhotos.clear();
    _amountAskedController.clear();
    _amountPaidController.clear();
    _locationController.text = _locationName;
    _notesController.clear();
  }

  Future<void> _launchGovernmentComplaintPage() async {
    // Show confirmation dialog before submitting
    if (!mounted) return;
    
    final authorityEmail = _getAuthorityEmailForIssue(_issueType);
    final authorityName = _getAuthorityNameForIssue(_issueType);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report to Authorities'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your complaint will be submitted to:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorityName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.blue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authorityEmail,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your complete complaint details will be included. This is an official report that authorities will investigate.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final complaintDetails = _buildComplaintMessage();
      
      // Try email first, then portal
      final emailSent = await _sendComplaintViaEmail(authorityEmail, complaintDetails);
      if (emailSent != true) {
        await _openGovernmentComplaintPortal(complaintDetails);
      }
    }
  }

  String _getAuthorityNameForIssue(String issueType) {
    switch (issueType) {
      case 'overcharging':
      case 'no_receipt':
        return 'Central Consumer Protection Authority (CCPA)';
      case 'bribe_request':
      case 'harassment':
        return 'Central Vigilance Commission (CVC)';
      case 'wrong_fine':
      case 'misleading':
        return 'Traffic Authority & Road Safety Department';
      default:
        return 'Department of Personnel & Training (GoI)';
    }
  }

  String _getAuthorityEmailForIssue(String issueType) {
    switch (issueType) {
      case 'overcharging':
      case 'no_receipt':
        return 'consumer.complaints@fcais.gov.in'; // Central Consumer Protection Authority
      case 'bribe_request':
      case 'harassment':
        return 'prevention.corruption@cvc.gov.in'; // Central Vigilance Commission
      case 'wrong_fine':
      case 'misleading':
        return 'traffic.complaints@traffic.gov.in'; // Traffic Authority
      default:
        return 'grievances@dopt.gov.in'; // Department of Personnel & Training
    }
  }

  String _buildComplaintMessage() {
    final dateTime = DateTime.now().toString().split('.')[0];
    final amount = _amountAsked != null ? '₹${_amountAsked?.toStringAsFixed(2)}' : 'Not specified';
    
    return '''
OFFICIAL COMPLAINT - CivicShield Report
========================================

Report Date: $dateTime
Location: $_locationName
Category: $_violationCategory

ISSUE TYPE: ${_issueType.replaceAll('_', ' ').toUpperCase()}

DETAILS:
Amount Asked: $amount
Amount Paid: ${_amountPaid != null ? '₹${_amountPaid?.toStringAsFixed(2)}' : 'Not provided'}
Receipt Given: ${_receiptGiven ? 'No' : 'Yes'}

DESCRIPTION:
$_notes

COMPLAINT STATUS: Anonymous Report - ${_isAnonymous ? 'Yes' : 'No'}
PHOTO PROOF ATTACHED: ${_proofPhotos.isEmpty ? 'No' : 'Yes (${_proofPhotos.length} file(s))'}

${_proofPhotos.isEmpty ? '' : 'PROOF FILES:\n${_proofPhotos.asMap().entries.map((e) => '${e.key + 1}. ${_fileNameFromPath(e.value.path)}').join('\n')}\n'}

This is an automatic complaint generated through CivicShield - a civic engagement platform
for transparent and accountable governance.

Please acknowledge receipt and provide case reference number.

---
Generated automatically from CivicShield Application
    ''';
  }

  Future<void> _pickProofPhoto() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 82,
        maxWidth: 1920,
      );

      if (photo == null) {
        return;
      }

      final bytes = await photo.readAsBytes();
      if (!mounted) return;

      setState(() {
        _proofPhotos.add(_ProofPhoto(path: photo.path, bytes: bytes));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not upload photo: $e'),
          backgroundColor: CivicShieldTheme.dangerRed,
        ),
      );
    }
  }

  void _removeProofPhoto(int index) {
    setState(() {
      _proofPhotos.removeAt(index);
    });
  }

  String _fileNameFromPath(String path) {
    if (path.isEmpty) return 'photo';
    final normalized = path.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isNotEmpty ? parts.last : path;
  }

  Future<bool?> _sendComplaintViaEmail(String emailAddress, String complaintMessage) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        queryParameters: {
          'subject': 'OFFICIAL COMPLAINT - ${_issueType.replaceAll('_', ' ').toUpperCase()} at $_locationName',
          'body': complaintMessage,
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Complaint opened in your email client to send to: $emailAddress'),
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.green,
            ),
          );
        }
        return true;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _openGovernmentComplaintPortal(String complaintDetails) async {
    // Build URL with complaint details as parameters for CPGRAMS
    const cpgramsUrl = 'https://cpgrams.dopt.gov.in/';
    const pgPortalUrl = 'https://pgportal.nic.in/';

    try {
      final Uri cpgramsUri = Uri.parse(cpgramsUrl);
      if (await canLaunchUrl(cpgramsUri)) {
        await launchUrl(cpgramsUri, mode: LaunchMode.externalApplication);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Opening CPGRAMS portal to file your complaint'),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        // Fallback to public grievance portal
        final Uri pgUri = Uri.parse(pgPortalUrl);
        if (await canLaunchUrl(pgUri)) {
          await launchUrl(pgUri, mode: LaunchMode.externalApplication);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Opening Public Grievance Portal'),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.blue,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open government portal. Please manually visit:\nhttps://cpgrams.dopt.gov.in/'),
                duration: Duration(seconds: 5),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching portal: $e'),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReviewRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: CivicShieldTheme.textMuted, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: CivicShieldTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _ReceiptButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  const _ReceiptButton({required this.label, required this.icon, required this.isSelected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.12) : CivicShieldTheme.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : CivicShieldTheme.borderGlow, width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : CivicShieldTheme.textMuted, size: 24),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(
                color: isSelected ? color : CivicShieldTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProofPhoto {
  final String path;
  final Uint8List bytes;

  _ProofPhoto({required this.path, required this.bytes});
}
