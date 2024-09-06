import 'dart:developer';

import 'package:ai_overthinking/utils/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerationService {
  Future<GenerateContentResponse?> getText(String message,
      {List<Content>? history}) async {
    try {
      log("history $history");
      final model = GenerativeModel(
          model: 'gemini-1.5-flash-latest', apiKey: Environment.token);
      // GenerativeModel(model: 'gemini-pro', apiKey: Environment.token);
      ChatSession chat = model.startChat(history: history);
      final response = await chat.sendMessage(
        Content.text(message),
      );
      return response;
    } catch (e) {
      log("Error is $e");
    }
    return null;
  }
}
