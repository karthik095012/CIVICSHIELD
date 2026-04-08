import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../providers/preferences_provider.dart';
import '../../services/ollama_service.dart';

class AILegalConsultancyScreen extends ConsumerStatefulWidget {
  const AILegalConsultancyScreen({super.key});

  @override
  ConsumerState<AILegalConsultancyScreen> createState() => _AILegalConsultancyScreenState();
}

class _AILegalConsultancyScreenState extends ConsumerState<AILegalConsultancyScreen> {
  late TextEditingController _questionController;
  late TextEditingController _endpointController;
  late ScrollController _scrollController;
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isConnected = false;
  bool _checkedConnection = false;
  String _currentEndpoint = '';

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _endpointController = TextEditingController();
    _scrollController = ScrollController();
    _checkOllamaConnection();
  }

  Future<void> _checkOllamaConnection() async {
    setState(() {
      _checkedConnection = false;
    });

    final reachable = await OllamaService().autoDetectReachableBaseUrl();
    final endpoint = await OllamaService().getBaseUrl();

    setState(() {
      _isConnected = reachable != null;
      _checkedConnection = true;
      _currentEndpoint = endpoint;
      _endpointController.text = endpoint;
    });
  }

  Future<void> _openEndpointDialog() async {
    _endpointController.text = _currentEndpoint.isNotEmpty
        ? _currentEndpoint
        : await OllamaService().getBaseUrl();

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Ollama Server URL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'For real Android phones, use your laptop IP (same Wi-Fi), for example: 192.168.1.20:11434',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _endpointController,
                decoration: const InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'http://192.168.1.20:11434',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await OllamaService().setBaseUrl(_endpointController.text);
                if (mounted) {
                  Navigator.pop(context);
                }
                await _checkOllamaConnection();
              },
              child: const Text('Save & Retry'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(_ChatMessage(text: question, isUser: true));
      _messages.add(_ChatMessage(text: '', isUser: false));
      _isLoading = true;
    });

    _questionController.clear();
    _scrollToBottom();

    // Get AI response
    final buffer = StringBuffer();
    try {
      await for (final chunk in OllamaService().askLegalQuestion(question)) {
        buffer.write(chunk);
        setState(() {
          if (_messages.isNotEmpty && !_messages.last.isUser) {
            _messages.last = _ChatMessage(text: buffer.toString(), isUser: false);
          }
        });
        _scrollToBottom();
      }
    } catch (e) {
      buffer.write('Error: ${e.toString()}');
    }

    if (buffer.isEmpty && !_isConnected) {
      setState(() {
        _messages.last = _ChatMessage(
          text: 'Unable to connect to AI service at $_currentEndpoint. Tap "Set Server URL" and try again.',
          isUser: false,
        );
      });
    } else if (buffer.toString().isEmpty) {
      setState(() {
        _messages.last = _ChatMessage(
          text: 'No response received. Please try again.',
          isUser: false,
        );
      });
    }

    setState(() {
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _endpointController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final bgColor = isDarkMode ? CivicShieldTheme.darkBg : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('AI Legal Advisor'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Set Server URL',
            onPressed: _openEndpointDialog,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _isConnected
                      ? const Color(0xFFC8E6C9).withOpacity(0.3)
                      : const Color(0xFFFFEBEE).withOpacity(0.3),
                  border: Border(
                    bottom: BorderSide(
                      color: CivicShieldTheme.borderGlow,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _checkedConnection
                                ? (_isConnected ? const Color(0xFF43A047) : const Color(0xFFE53935))
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _checkedConnection
                              ? (_isConnected ? '✓ AI Service Connected' : '✗ AI Service Offline')
                              : 'Checking connection...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _checkedConnection
                                ? (_isConnected ? const Color(0xFF43A047) : const Color(0xFFE53935))
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Server: ${_currentEndpoint.isEmpty ? 'Detecting...' : _currentEndpoint}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: CivicShieldTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: _checkedConnection
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E88E5).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.smart_toy_rounded,
                                    size: 40,
                                    color: Color(0xFF1E88E5),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'AI Legal Advisor',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: CivicShieldTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '💰 Completely Free\n📚 Powered by Ollama AI\n⚖️ Indian Legal Guidance',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CivicShieldTheme.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F8E9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF43A047).withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Try asking about:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF43A047),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '• "What should I do if I receive a fake traffic challan?"\n• "Can I challenge a parking fine?"\n• "What are my rights during a traffic check?"\n• "How do I file a complaint against police harassment?"',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: CivicShieldTheme.textSecondary,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_off_rounded,
                                  size: 60,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'AI Service Not Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: CivicShieldTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    'To connect AI on a phone:\n\n1. On laptop run:\nOLLAMA_HOST=0.0.0.0:11434 ollama serve\n2. Keep phone and laptop on same Wi-Fi\n3. Tap "Set Server URL" and enter:\nhttp://<laptop-ip>:11434\n4. Retry connection',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CivicShieldTheme.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _checkOllamaConnection,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E88E5),
                                      ),
                                      child: const Text('Retry Connection'),
                                    ),
                                    OutlinedButton(
                                      onPressed: _openEndpointDialog,
                                      child: const Text('Set Server URL'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _ChatBubble(
                      message: _messages[index],
                      isDarkMode: isDarkMode,
                    ),
                  ),
          ),
          // Input area
          if (_isConnected)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDarkMode ? CivicShieldTheme.darkSurfaceCard : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: CivicShieldTheme.borderGlow,
                    width: 1,
                                  ),
                ),
              ),
              child: Column(
                children: [
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                const Color(0xFF1E88E5).withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'AI is thinking...',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: CivicShieldTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _questionController,
                          enabled: !_isLoading,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Ask a legal question...',
                            hintStyle: const TextStyle(color: CivicShieldTheme.textMuted),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: CivicShieldTheme.borderGlow,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: CivicShieldTheme.borderGlow,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: CivicShieldTheme.accentCyan,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _sendQuestion,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🔒 Your questions are processed on your configured Ollama server.',
                    style: TextStyle(
                      fontSize: 10,
                      color: CivicShieldTheme.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDarkMode;

  const _ChatBubble({
    required this.message,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF1E88E5)
              : (isDarkMode ? CivicShieldTheme.darkSurfaceCard : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(14),
          border: !message.isUser
              ? Border.all(
                  color: CivicShieldTheme.borderGlow,
                  width: 1,
                )
              : null,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 12,
            color: message.isUser ? Colors.white : CivicShieldTheme.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
