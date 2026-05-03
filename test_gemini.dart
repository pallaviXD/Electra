import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

void main() async {
  final apiKey = 'REPLACE_WITH_YOUR_GROQ_KEY';
  print('Testing Gemini API with key: ' + apiKey);
  
  try {
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
    
    final response = await model.generateContent([Content.text('Hello! Are you working?')]);
    print('Response: ' + (response.text ?? 'null'));
    exit(0);
  } catch (e) {
    print('Error: ' + e.toString());
    exit(1);
  }
}
