import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Use a default API key if the environment variable is not set.
  // Note: For production, consider using a more secure way to manage keys, like cloud functions.
  // The provided key is a placeholder and should be replaced with a valid one if needed.
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'AIzaSyBCXqKs70ftJWxW3nMKd-4APE0sbheVtUU');
  
  // Set this to true to use mock responses and avoid API costs during development.
  static const bool _useMock = true;

  late final GenerativeModel _model;
  bool _isConfigured = false;

  GeminiService() {
    if (_useMock) {
      print('GeminiService: Using Mock Mode to save costs.');
      return;
    }

    if (_apiKey.isNotEmpty) {
       // 'gemini-pro' was deprecated/moved. 'gemini-1.5-flash' is often recommended for better performance/latency
       // or 'gemini-1.0-pro' if you need the older behavior. 
       // 'gemini-1.5-flash' has a free tier available in Google AI Studio.
       _model = GenerativeModel(
        model: 'gemini-1.5-flash', 
        apiKey: _apiKey,
      );
      _isConfigured = true;
    } else {
      print('Warning: GEMINI_API_KEY is not set.');
    }
  }

  Future<String> generateResponse(String prompt) async {
    if (_useMock) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return "I am a mock AI assistant. I am used to avoid API costs during development. You asked: \"$prompt\"";
    }

    if (!_isConfigured) {
      return "I can't chat right now because my brain (API Key) is missing. Please tell the developer to add it!";
    }

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "I'm having trouble understanding that right now.";
    } catch (e) {
      print('Gemini API Error: $e');
      return "I'm sorry, I encountered an error while thinking. Please try again later. ($e)";
    }
  }
  
  Stream<String> generateStreamResponse(String prompt) async* {
    if (_useMock) {
      // Simulate network delay and streaming
      await Future.delayed(const Duration(seconds: 1));
      final responseText = "I am a mock AI assistant (streaming). I am used to avoid API costs during development. You asked: \"$prompt\"";
      final words = responseText.split(' ');
      for (final word in words) {
        await Future.delayed(const Duration(milliseconds: 100));
        yield "$word ";
      }
      return;
    }

    if (!_isConfigured) {
      yield "I can't chat right now because my brain (API Key) is missing. Please tell the developer to add it!";
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
       print('Gemini Stream API Error: $e');
      yield "I'm sorry, I encountered an error while thinking. Please try again later.";
    }
  }
}
