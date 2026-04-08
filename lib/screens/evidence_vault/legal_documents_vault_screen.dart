import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../app/theme.dart';
import '../../models/legal_document_model.dart';
import '../../providers/legal_documents_provider.dart';

class LegalDocumentsVaultScreen extends ConsumerStatefulWidget {
  const LegalDocumentsVaultScreen({super.key});

  @override
  ConsumerState<LegalDocumentsVaultScreen> createState() =>
      _LegalDocumentsVaultScreenState();
}

class _LegalDocumentsVaultScreenState
    extends ConsumerState<LegalDocumentsVaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all'; // all, pdf, audio, video, image, doc
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(legalDocumentsProvider);
    final stats = ref.watch(documentStatsProvider);
    
    final filteredDocs = _selectedFilter == 'all'
        ? documents
        : documents.where((doc) => doc.fileType.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    
    final searchedDocs = _searchQuery.isEmpty
        ? filteredDocs
        : ref.watch(searchDocumentsProvider(_searchQuery));

    return Scaffold(
      backgroundColor: CivicShieldTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: CivicShieldTheme.surfaceDark,
        elevation: 0,
        title: const Text(
          'Legal Documents Vault',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: CivicShieldTheme.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Container(height: 1, color: CivicShieldTheme.borderGlow),
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search documents, clients, cases...',
                    prefixIcon: const Icon(Icons.search, color: CivicShieldTheme.textMuted),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: CivicShieldTheme.borderGlow),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              // File type filter chips
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      _buildFilterChip('📄 PDF', 'pdf'),
                      _buildFilterChip('🎯 PPT', 'ppt'),
                      _buildFilterChip('🔊 Audio', 'audio'),
                      _buildFilterChip('🎥 Video', 'video'),
                      _buildFilterChip('🖼️ Image', 'image'),
                      _buildFilterChip('📋 Docs', 'doc'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context),
        backgroundColor: CivicShieldTheme.primaryDeepTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Upload Document'),
      ),
      body: searchedDocs.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
              itemCount: searchedDocs.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) return _buildDocumentsHeader(searchedDocs.length);
                final doc = searchedDocs[i - 1];
                return _DocumentCard(document: doc);
              },
            ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
        },
        backgroundColor: Colors.transparent,
        selectedColor: CivicShieldTheme.primaryDeepTeal.withOpacity(0.2),
        side: BorderSide(
          color: isSelected
              ? CivicShieldTheme.primaryDeepTeal
              : Colors.grey[400]!,
        ),
      ),
    );
  }

  Widget _buildDocumentsHeader(int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CivicShieldTheme.primaryDeepTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CivicShieldTheme.primaryDeepTeal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_open, color: CivicShieldTheme.primaryDeepTeal, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count Document${count != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: CivicShieldTheme.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'Encrypted • Stored locally • Organized by type',
                  style: TextStyle(
                    fontSize: 11,
                    color: CivicShieldTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CivicShieldTheme.primaryDeepTeal.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: CivicShieldTheme.primaryDeepTeal.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.insert_drive_file_outlined,
              size: 40,
              color: CivicShieldTheme.primaryDeepTeal,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No documents found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: CivicShieldTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Upload legal documents, case files, and evidence to organize your client matters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CivicShieldTheme.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showUploadDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Upload First Document'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CivicShieldTheme.primaryDeepTeal,
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CivicShieldTheme.surfaceCard,
        title: const Text('Upload Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUploadOption('📄 PDF', 'pdf'),
            _buildUploadOption('🎯 Presentation (PPT)', 'ppt'),
            _buildUploadOption('🔊 Audio (MP3, WAV)', 'audio'),
            _buildUploadOption('🎥 Video (MP4, MOV)', 'video'),
            _buildUploadOption('🖼️ Image (JPG, PNG)', 'image'),
            _buildUploadOption('📋 Document (DOC, DOCX)', 'doc'),
            _buildUploadOption('📊 Spreadsheet (XLSX)', 'excel'),
            _buildUploadOption('📝 Text File (TXT)', 'txt'),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(String label, String type) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () async {
        Navigator.pop(context);
        await _uploadDocument(type);
      },
    );
  }

  Future<void> _uploadDocument(String fileType) async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile;

      // For simplicity, we'll use image picker for all files
      // In production, you'd use a more comprehensive file picker
      pickedFile = await picker.pickMedia();

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Show document details dialog
        _showDocumentDetailsDialog(
          context,
          fileName: pickedFile.name,
          fileType: fileType,
          filePath: pickedFile.path,
          fileSize: fileSize,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing file: $e')),
      );
    }
  }

  void _showDocumentDetailsDialog(
    BuildContext context, {
    required String fileName,
    required String fileType,
    required String filePath,
    required int fileSize,
  }) {
    final clientController = TextEditingController();
    final caseController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CivicShieldTheme.surfaceCard,
        title: const Text('Document Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File: $fileName',
                style: const TextStyle(
                  fontSize: 12,
                  color: CivicShieldTheme.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: clientController,
                decoration: InputDecoration(
                  labelText: 'Client Name (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: caseController,
                decoration: InputDecoration(
                  labelText: 'Case Number (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final document = LegalDocument(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                fileName: fileName,
                fileType: fileType,
                clientName: clientController.text.isNotEmpty ? clientController.text : null,
                caseNumber: caseController.text.isNotEmpty ? caseController.text : null,
                description: descController.text.isNotEmpty ? descController.text : null,
                uploadedAt: DateTime.now(),
                fileSizeBytes: fileSize,
                filePath: filePath,
                status: 'saved',
                tags: [],
                isEncrypted: true,
              );

              ref.read(legalDocumentsProvider.notifier).addDocument(document);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Document "$fileName" saved successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CivicShieldTheme.primaryDeepTeal,
            ),
            child: const Text('Save Document'),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends ConsumerWidget {
  final LegalDocument document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CivicShieldTheme.primaryDeepTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(document.getFileTypeIcon(), style: const TextStyle(fontSize: 24)),
        ),
        title: Text(
          document.fileName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.clientName != null)
              Text(
                '👤 ${document.clientName}',
                style: const TextStyle(fontSize: 12),
              ),
            Text(
              '${document.getFormattedSize()} • ${document.getFileTypeLabel()} • ${_formatDate(document.uploadedAt)}',
              style: const TextStyle(fontSize: 11, color: CivicShieldTheme.textMuted),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('📋 View Details'),
              onTap: () => _showDocumentDetails(context, document),
            ),
            PopupMenuItem(
              child: const Text('🗑️ Delete'),
              onTap: () => _deleteDocument(context, ref, document),
            ),
          ],
        ),
        onTap: () => _showDocumentDetails(context, document),
      ),
    );
  }

  void _showDocumentDetails(BuildContext context, LegalDocument doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CivicShieldTheme.surfaceCard,
        title: Text(doc.fileName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', doc.getFileTypeLabel()),
              _buildDetailRow('Size', doc.getFormattedSize()),
              _buildDetailRow('Uploaded', _formatDate(doc.uploadedAt)),
              if (doc.clientName != null)
                _buildDetailRow('Client', doc.clientName!),
              if (doc.caseNumber != null)
                _buildDetailRow('Case', doc.caseNumber!),
              if (doc.description != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(doc.description!),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Encrypted & Secure',
                      style: TextStyle(fontSize: 12, color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteDocument(BuildContext context, WidgetRef ref, LegalDocument doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text('Are you sure you want to delete "${doc.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(legalDocumentsProvider.notifier).removeDocument(doc.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
