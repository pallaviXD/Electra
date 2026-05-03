import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/ai_orchestrator.dart';
import '../services/trust_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  void initialize(String apiKey) {
    if (!_isInitialized) {
      GeminiService.instance.initialize(apiKey);
      _isInitialized = true;
    }
  }

  Future<void> sendMessage(String content, {String language = 'English'}) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    // Get AI response via Orchestrator
    final response = await AiOrchestrator.instance.processRequest(
      type: AITaskType.chat,
      input: content,
      language: language,
    );

    // Get Trust Metadata
    final metadata = TrustService.instance.getMetadataForResponse(response);

    // Generate suggestion chips based on context
    final suggestions = _generateSuggestions(content);

    final aiMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: suggestions,
      trustMetadata: metadata,
    );
    _messages.add(aiMessage);
    _isLoading = false;
    notifyListeners();
  }

  List<String> _generateSuggestions(String lastQuery) {
    final lower = lastQuery.toLowerCase();
    if (lower.contains('vote') || lower.contains('voting')) {
      return ['How to register?', 'What ID do I need?', 'Polling booth hours'];
    } else if (lower.contains('candidate') || lower.contains('party')) {
      return ['Compare candidates', 'View manifesto', 'Past performance'];
    } else if (lower.contains('result') || lower.contains('winner')) {
      return ['What happens next?', 'Government formation', 'Promise tracker'];
    } else if (lower.contains('eligib')) {
      return ['Check my eligibility', 'Age requirement', 'Registration deadline'];
    }
    return ['How to vote?', 'Election timeline', 'Check eligibility'];
  }

  void clearChat() {
    _messages.clear();
    GeminiService.instance.resetChat();
    notifyListeners();
  }
}
