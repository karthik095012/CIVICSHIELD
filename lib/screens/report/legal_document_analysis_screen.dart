import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/document_analysis_model.dart';
import '../../providers/document_analysis_provider.dart';
import '../../app/theme.dart';

class LegalDocumentAnalysisScreen extends ConsumerWidget {
  const LegalDocumentAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(documentAnalysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Case - Legal Analysis'),
        elevation: 0,
        backgroundColor: CivicShieldTheme.primaryDeepTeal,
      ),
      body: analysisState.isLoading
          ? _buildLoadingState(context)
          : analysisState.analysis != null
              ? _buildAnalysisResults(context, ref, analysisState.analysis!)
              : _buildUploadScreen(context, ref),
    );
  }

  // Upload screen - initial state
  Widget _buildUploadScreen(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Upload icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: CivicShieldTheme.primaryDeepTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.file_present_rounded,
                size: 60,
                color: CivicShieldTheme.primaryDeepTeal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Legal Document',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Upload a PDF, text file, or image of a legal document\nfor AI-powered analysis using Ollama',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Features preview
            _buildFeatureCard(
              context,
              icon: Icons.description_outlined,
              title: 'Case Analysis',
              description: 'Analyze documents, applicable laws, and precedents',
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              icon: Icons.trending_up,
              title: 'Case Prediction',
              description: 'Predict outcomes with explainability scores',
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              icon: Icons.balance,
              title: 'Bias Detection',
              description: 'Detect potential bias in judicial decisions',
            ),
            const SizedBox(height: 40),
            // Upload button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _uploadDocument(context, ref),
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Select Document'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CivicShieldTheme.primaryDeepTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ensure Ollama is running:\nhttp://localhost:11434',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Loading state
  Widget _buildLoadingState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: CivicShieldTheme.primaryDeepTeal,
        ),
        const SizedBox(height: 16),
        Text(
          'Analyzing document with Ollama...\nThis may take a few minutes',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // Analysis results screen
  Widget _buildAnalysisResults(
      BuildContext context, WidgetRef ref, DocumentAnalysis analysis) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document info
            _buildDocumentHeader(context, analysis),
            const SizedBox(height: 24),
            // Case Analysis
            _buildSectionCard(
              context,
              title: 'Case Analysis',
              icon: Icons.description_outlined,
              child: _buildCaseAnalysis(context, analysis.caseAnalysis),
            ),
            const SizedBox(height: 18),
            // Case Prediction
            _buildSectionCard(
              context,
              title: 'Case Prediction & Outcome',
              icon: Icons.trending_up,
              child: _buildCasePrediction(context, analysis.casePrediction),
            ),
            const SizedBox(height: 18),
            // Bias Detection
            _buildSectionCard(
              context,
              title: 'Bias Detection Analysis',
              icon: Icons.balance,
              child: _buildBiasDetection(context, analysis.biasDetection),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(documentAnalysisProvider.notifier).clearAnalysis();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Analyze Another'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CivicShieldTheme.primaryDeepTeal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentHeader(
      BuildContext context, DocumentAnalysis analysis) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.file_present_rounded,
                  color: CivicShieldTheme.primaryDeepTeal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        analysis.documentName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Analyzed: ${DateTime.parse(analysis.uploadedAt).toString().split('.')[0]}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: CivicShieldTheme.primaryDeepTeal, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCaseAnalysis(BuildContext context, CaseAnalysis analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryBox(context, 'Summary', analysis.summary),
        const SizedBox(height: 16),
        _buildListSection(context, 'Key Points', analysis.keyPoints),
        const SizedBox(height: 16),
        _buildDetailSection(context, 'Applicable Laws', analysis.applicableLaws),
        const SizedBox(height: 16),
        _buildDetailSection(context, 'Legal Precedents', analysis.precedents),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailBox(
                context,
                'Strengths',
                analysis.strengths,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailBox(
                context,
                'Weaknesses',
                analysis.weaknesses,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCasePrediction(BuildContext context, CasePrediction prediction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success probability
        _buildProbabilityCard(context, prediction.successProbability),
        const SizedBox(height: 16),
        // Outcome prediction
        _buildDetailSection(context, 'Predicted Outcome',
            prediction.outcomePredictor),
        const SizedBox(height: 16),
        // Key factors
        _buildListSection(context, 'Influencing Factors', prediction.factors),
        const SizedBox(height: 16),
        // Recommendation
        _buildDetailSection(
            context, 'Recommendations', prediction.recommendation),
        const SizedBox(height: 16),
        // Explainability
        _buildDetailSection(
            context, 'Why This Prediction?', prediction.explainability),
      ],
    );
  }

  Widget _buildBiasDetection(BuildContext context, BiasDetection detection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bias status
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: detection.biasDetected ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: detection.biasDetected ? Colors.red : Colors.green,
            ),
          ),
          child: Row(
            children: [
              Icon(
                detection.biasDetected
                    ? Icons.warning_rounded
                    : Icons.check_circle,
                color:
                    detection.biasDetected ? Colors.red[700] : Colors.green[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detection.biasDetected
                          ? 'Bias Indicators Found'
                          : 'No Significant Bias Detected',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Risk Level: ${detection.riskLevel.toUpperCase()}',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Bias indicators
        if (detection.indicators.isNotEmpty) ...[
          Text(
            'Identified Bias Indicators:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...detection.indicators
              .map((indicator) => _buildBiasIndicatorTile(context, indicator))
              .toList(),
          const SizedBox(height: 16),
        ],
        // Fairness score
        _buildDetailSection(
            context, 'Fairness Score', detection.fairnessScore),
        const SizedBox(height: 16),
        // Recommendations
        _buildDetailSection(
            context, 'Counter-Bias Recommendations', detection.recommendations),
      ],
    );
  }

  Widget _buildSummaryBox(
      BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content.isNotEmpty ? content : 'Analysis pending...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailBox(BuildContext context, String title, String content,
      Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content.isNotEmpty ? content : 'Not specified',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(
      BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...items
            .map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 18, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
        if (items.isEmpty)
          Text(
            'No items listed',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
      ],
    );
  }

  Widget _buildDetailSection(
      BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content.isNotEmpty ? content : 'Analysis pending...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildProbabilityCard(BuildContext context, int probability) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CivicShieldTheme.primaryDeepTeal,
            CivicShieldTheme.primaryDeepTeal.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Success Probability',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: probability / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$probability% Likelihood',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiasIndicatorTile(BuildContext context, BiasIndicator indicator) {
    final severityColor = indicator.severity == 'high'
        ? Colors.red
        : indicator.severity == 'medium'
            ? Colors.orange
            : Colors.yellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: severityColor, width: 4),
        ),
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  indicator.type.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  indicator.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Chip(
            label: Text(indicator.severity.toUpperCase()),
            backgroundColor: severityColor.withOpacity(0.3),
            labelStyle: TextStyle(
              fontSize: 11,
              color: severityColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: CivicShieldTheme.primaryDeepTeal, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadDocument(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(documentAnalysisProvider.notifier).pickDocument();
      
      final state = ref.read(documentAnalysisProvider);
      if (state.selectedFilePath != null) {
        final fileName = state.selectedFilePath!.split('/').last;
        
        // Determine file type
        String fileType = 'text';
        if (fileName.endsWith('.pdf')) {
          fileType = 'pdf';
        } else if (fileName.endsWith('.png') ||
            fileName.endsWith('.jpg') ||
            fileName.endsWith('.jpeg')) {
          fileType = 'image';
        }

        // Analyze document
        await ref.read(documentAnalysisProvider.notifier).analyzeDocument(
          filePath: state.selectedFilePath!,
          documentName: fileName,
          documentType: fileType,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
