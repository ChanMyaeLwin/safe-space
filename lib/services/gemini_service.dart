import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // TODO: Replace with your actual API key or use --dart-define=GEMINI_API_KEY=...
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  
  late final GenerativeModel _model;

  GeminiService() {
    if (_apiKey.isEmpty) {
      print('Warning: GEMINI_API_KEY is not set.');
    }
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  Future<String> generateResponse(String prompt) async {
    if (_apiKey.isEmpty) {
      return "Please configure your Gemini API Key in the application.";
    }

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "I'm having trouble understanding that right now.";
    } catch (e) {
      return "Error: $e";
    }
  }
  
  Stream<String> generateStreamResponse(String prompt) async* {
      if (_apiKey.isEmpty) {
      yield "Please configure your Gemini API Key in the application.";
      return;
    }

    try {
      final content = [Content.text(prompt)];
      final response = _model.generateContentStream(content);
      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      yield "Error: $e";
    }
  }
}
