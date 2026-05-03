import 'package:flutter/foundation.dart';
import 'gemini_service.dart';

enum AITaskType { chat, manifesto, misinformation, quiz }

class AiOrchestrator {
  static final AiOrchestrator instance = AiOrchestrator._();
  
  AiOrchestrator._();

  // Safety Rules check for sensitive political queries
  bool _isSensitiveQuery(String query) {
    final lowerQuery = query.toLowerCase();
    final sensitivePhrases = [
      'who should i vote for',
      'which party is best',
      'who is better',
      'who to vote for',
      'best candidate',
      'should i vote for',
    ];
    
    for (var phrase in sensitivePhrases) {
      if (lowerQuery.contains(phrase)) return true;
    }
    return false;
  }

  String _getSensitiveResponse() {
    return 'As an AI, I remain strictly neutral. I cannot recommend who to vote for or which party is "best". I encourage you to review the candidates\' past performance, read their manifestos, and make an independent decision based on your own values.';
  }

  Future<String> processRequest({
    required AITaskType type,
    required String input,
    String? location,
    String? language,
  }) async {
    // 1. Sensitive query check (especially for chat)
    if (type == AITaskType.chat && _isSensitiveQuery(input)) {
      return _getSensitiveResponse();
    }

    // 2. Context Injection
    String contextPrompt = '';
    if (location != null || (language != null && language != 'English')) {
      contextPrompt = 'Context Info:';
      if (language != null) contextPrompt += ' User preferred language is $language.';
      if (location != null) contextPrompt += ' User location is $location.';
      contextPrompt += '\n\n';
    }

    // 3. Routing
    try {
      switch (type) {
        case AITaskType.chat:
          // The ChatSession manages history, so we just pass context and the query
          final prompt = '$contextPrompt$input';
          return await GeminiService.instance.sendMessage(prompt);
          
        case AITaskType.manifesto:
          final prompt = '${contextPrompt}Simplify the following manifesto into easy, neutral bullet points. Do not add opinion.\n\n$input';
          return await GeminiService.instance.generateContent(prompt);
          
        case AITaskType.misinformation:
          return await GeminiService.instance.generateContent(
            '${contextPrompt}Fact-check this claim neutrally. Return exactly JSON with verdict (TRUE/FALSE/MISLEADING/UNVERIFIED), confidence (0-100), explanation, and reasoning:\n\n"$input"'
          );
          
        case AITaskType.quiz:
          return await GeminiService.instance.generateContent(
            '${contextPrompt}Analyze these user preferences and provide an objective breakdown of how they align with general political ideologies. Do not recommend a specific party:\n\n$input'
          );
      }
    } catch (e) {
      if (kDebugMode) print('AI Orchestrator Error: $e');
      return _getFallbackResponse(type);
    }
  }

  String _getFallbackResponse(AITaskType type) {
    if (type == AITaskType.chat) {
      return "I'm having trouble connecting to my knowledge base right now. Please check your internet connection and try again.";
    }
    return "The service is temporarily unavailable. Please try again later.";
  }
}
