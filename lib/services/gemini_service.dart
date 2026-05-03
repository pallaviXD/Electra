import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

/// Uses Groq API (free, fast) with llama-3.3-70b model.
/// Get a free key at https://console.groq.com/keys
class GeminiService {
  static GeminiService? _instance;
  String _apiKey = '';
  final List<Map<String, String>> _chatHistory = [];

  GeminiService._();

  static GeminiService get instance {
    _instance ??= GeminiService._();
    return _instance!;
  }

  void initialize(String apiKey) {
    _apiKey = apiKey;
    _chatHistory.clear();
    // Seed with system prompt
    _chatHistory.add({
      'role': 'system',
      'content': AppConstants.geminiSystemPrompt,
    });
  }

  Future<String> sendMessage(String message) async {
    _chatHistory.add({'role': 'user', 'content': message});
    try {
      final result = await _callGroq(_chatHistory);
      _chatHistory.add({'role': 'assistant', 'content': result});
      return result;
    } catch (e) {
      if (kDebugMode) print('GeminiService.sendMessage error: $e');
      _chatHistory.removeLast(); // remove failed user message
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> generateContent(String prompt) async {
    try {
      return await _callGroq([
        {'role': 'system', 'content': AppConstants.geminiSystemPrompt},
        {'role': 'user', 'content': prompt},
      ]);
    } catch (e) {
      if (kDebugMode) print('GeminiService.generateContent error: $e');
      return 'Error generating content: ${e.toString()}';
    }
  }

  Future<String> _callGroq(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 2048,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      if (kDebugMode) print('Groq API error ${response.statusCode}: ${response.body}');
      throw Exception('API error ${response.statusCode}: ${response.body}');
    }
  }

  Future<String> simplifyManifesto(String manifestoText) async {
    return generateContent(
      'Simplify the following political manifesto into easy bullet points. Be neutral and factual.\n\n$manifestoText',
    );
  }

  Future<Map<String, dynamic>> checkMisinformation(String claim) async {
    final response = await generateContent(
      'Fact-check this claim. Respond ONLY in JSON: {"verdict":"TRUE/FALSE/MISLEADING/UNVERIFIED","confidence":0-100,"explanation":"brief","reasoning":"detailed"}\n\nClaim: $claim',
    );
    return {'raw': response, 'verdict': 'UNVERIFIED'};
  }

  Future<String> summarizeNews(String articleText) async {
    return generateContent(
      'Summarize this news article neutrally: what happened, why it matters, key facts.\n\n$articleText',
    );
  }

  void resetChat() {
    _chatHistory.clear();
    _chatHistory.add({
      'role': 'system',
      'content': AppConstants.geminiSystemPrompt,
    });
  }
}
