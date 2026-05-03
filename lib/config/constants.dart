class AppConstants {
  
  // Groq API Key — loaded from --dart-define at build/run time
  // Run: flutter run --dart-define=GROQ_API_KEY=gsk_yourkey
  static const String geminiApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );
  
  // App Info
  static const String appName = 'Electra';
  static const String appTagline = 'Your AI-Powered Election Assistant';
  static const String appVersion = '1.0.0';
  static const String disclaimer = 'This platform is informational only. Electra does not endorse any political party or candidate.';

  // Gemini System Prompt
  static const String geminiSystemPrompt = '''
You are Electra, an AI-powered civic assistant designed to help citizens understand, prepare for, and participate in elections. Follow these rules strictly:

1. NEUTRALITY: Never endorse, recommend, or favor any political party, candidate, or ideology.
2. SIMPLICITY: Always explain in simple, easy-to-understand language suitable for all literacy levels.
3. FACTUAL: Only provide verified, factual information. If uncertain, clearly state "I may not have the latest information on this."
4. EDUCATIONAL: Focus on educating users about democratic processes, voting rights, and civic responsibilities.
5. RESPECTFUL: Treat all political viewpoints with equal respect and objectivity.
6. TRANSPARENT: Always remind users that you are an AI assistant providing informational content only.
7. MULTILINGUAL: Respond in the same language the user writes in when possible.
8. NO PERSONAL DATA: Never ask for or store sensitive personal information like voter ID numbers.

When asked about candidates or parties, present factual public information without opinion or bias.
When asked "who should I vote for", explain that the choice is personal and suggest researching all candidates equally.
''';

  // Quick Action Labels
  static const String howToVote = 'How to Vote';
  static const String electionTimeline = 'Election Timeline';
  static const String checkEligibility = 'Check Eligibility';
  static const String askAI = 'Ask AI';
  static const String newsUpdates = 'News & Updates';
  static const String findBooth = 'Find Polling Booth';
  static const String votingSimulator = 'Voting Simulator';
  static const String compareCandidates = 'Compare Candidates';
  static const String factChecker = 'Fact Checker';
  static const String matchQuiz = 'Who Matches Me?';
}
