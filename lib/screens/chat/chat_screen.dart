import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/chat_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/trust_service.dart';
import '../../widgets/disclaimer_banner.dart';

class ChatScreen extends StatefulWidget {
  final String? initialQuery;

  const ChatScreen({super.key, this.initialQuery});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final chatProvider = context.read<ChatProvider>();
    chatProvider.initialize(AppConstants.geminiApiKey);

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatProvider.sendMessage(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    final language = context.read<SettingsProvider>().language;
    context.read<ChatProvider>().sendMessage(text, language: language);
    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElectraTheme.background,
      appBar: AppBar(
        backgroundColor: ElectraTheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: ElectraTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Electra AI',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ElectraTheme.textPrimary,
                  ),
                ),
                Text(
                  'Always neutral • Always factual',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: ElectraTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Language selector
          Consumer<SettingsProvider>(
            builder: (context, settings, _) => GestureDetector(
              onTap: () => _showLanguagePicker(context, settings),
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ElectraTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ElectraTheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.translate_rounded,
                        size: 14, color: ElectraTheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      settings.language == 'English'
                          ? 'EN'
                          : settings.language.substring(0, 2),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ElectraTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: () => context.read<ChatProvider>().clearChat(),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return Column(
            children: [
              // Messages
              Expanded(
                child: chatProvider.messages.isEmpty
                    ? _buildWelcomeView()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: chatProvider.messages.length +
                            (chatProvider.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == chatProvider.messages.length &&
                              chatProvider.isLoading) {
                            return _buildTypingIndicator();
                          }
                          final message = chatProvider.messages[index];
                          return _buildMessageBubble(message, chatProvider);
                        },
                      ),
              ),

              // Input Bar
              _buildInputBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: ElectraTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: ElectraTheme.shadowGreen,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hello! I\'m Electra',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: ElectraTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your AI-powered election assistant.\nAsk me anything about elections, voting, or candidates.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ElectraTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Suggestion Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _SuggestionChip(
                label: '🗳️ How do I vote?',
                onTap: () => _sendSuggestion('How do I vote in the elections?'),
              ),
              _SuggestionChip(
                label: '📋 Am I eligible?',
                onTap: () => _sendSuggestion('How do I check my voter eligibility?'),
              ),
              _SuggestionChip(
                label: '📅 Election dates',
                onTap: () => _sendSuggestion('What are the upcoming election dates?'),
              ),
              _SuggestionChip(
                label: '🔍 Compare candidates',
                onTap: () => _sendSuggestion('How can I compare candidates objectively?'),
              ),
              _SuggestionChip(
                label: '📰 Latest news',
                onTap: () => _sendSuggestion('What are the latest election updates?'),
              ),
              _SuggestionChip(
                label: '🏛️ How govt forms',
                onTap: () => _sendSuggestion('How is a government formed after elections?'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const DisclaimerBanner(),
        ],
      ),
    );
  }

  void _sendSuggestion(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider settings) {
    const languages = [
      {'code': 'English', 'label': 'English', 'native': 'English'},
      {'code': 'हिन्दी', 'label': 'Hindi', 'native': 'हिन्दी'},
      {'code': 'తెలుగు', 'label': 'Telugu', 'native': 'తెలుగు'},
      {'code': 'தமிழ்', 'label': 'Tamil', 'native': 'தமிழ்'},
      {'code': 'ಕನ್ನಡ', 'label': 'Kannada', 'native': 'ಕನ್ನಡ'},
      {'code': 'मराठी', 'label': 'Marathi', 'native': 'मराठी'},
      {'code': 'বাংলা', 'label': 'Bengali', 'native': 'বাংলা'},
      {'code': 'ગુજરાતી', 'label': 'Gujarati', 'native': 'ગુજરાતી'},
      {'code': 'ਪੰਜਾਬੀ', 'label': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
      {'code': 'മലയാളം', 'label': 'Malayalam', 'native': 'മലയാളം'},
      {'code': 'اردو', 'label': 'Urdu', 'native': 'اردو'},
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ElectraTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chat Language',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Electra will respond in your selected language',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: ElectraTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: languages
                    .map((l) => ListTile(
                          dense: true,
                          title: Text(l['label']!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text(l['native']!,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: ElectraTheme.textTertiary)),
                          trailing: settings.language == l['code']
                              ? const Icon(Icons.check_circle_rounded,
                                  color: ElectraTheme.primary)
                              : null,
                          onTap: () {
                            settings.setLanguage(l['code']!);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message, ChatProvider chatProvider) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(top: 4, right: 8),
                  decoration: BoxDecoration(
                    gradient: ElectraTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? ElectraTheme.primary
                        : ElectraTheme.cardBg,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: ElectraTheme.shadowSm,
                  ),
                  child: Text(
                    message.content,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: isUser ? Colors.white : ElectraTheme.textPrimary,
                    ),
                  ),
                ),
              ),
              if (isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(top: 4, left: 8),
                  decoration: BoxDecoration(
                    color: ElectraTheme.textTertiary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: ElectraTheme.textSecondary,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
          // Trust Metadata
          if (!isUser && message.trustMetadata != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 36, right: 16),
              child: TrustMetadataWidget(metadata: message.trustMetadata!),
            ),
          ],
          // Suggestion chips after AI message
          if (!isUser && message.suggestions != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: message.suggestions!
                    .map<Widget>((s) => _SuggestionChip(
                          label: s,
                          onTap: () => _sendSuggestion(s),
                          small: true,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: ElectraTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: ElectraTheme.cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: ElectraTheme.shadowSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 600 + (i * 200)),
                  builder: (context, value, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ElectraTheme.primary.withValues(
                          alpha: 0.3 + (value * 0.5),
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: ElectraTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ElectraTheme.background,
                borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
                border: Border.all(color: ElectraTheme.divider),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        hintStyle: GoogleFonts.inter(
                          color: ElectraTheme.textTertiary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: ElectraTheme.textPrimary,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none_rounded, size: 22),
                    color: ElectraTheme.textTertiary,
                    onPressed: () {
                      // Voice input - future implementation
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: ElectraTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: ElectraTheme.shadowGreen,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool small;

  const _SuggestionChip({
    required this.label,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 10 : 14,
          vertical: small ? 6 : 10,
        ),
        decoration: BoxDecoration(
          color: ElectraTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(ElectraTheme.radiusRound),
          border: Border.all(
            color: ElectraTheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: small ? 12 : 13,
            fontWeight: FontWeight.w500,
            color: ElectraTheme.primaryDark,
          ),
        ),
      ),
    );
  }
}
