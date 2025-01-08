import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  static final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  // This method calls OpenAI's text completion or chat completion endpoint to generate an affirmation
  static Future<String> generateAffirmation() async {
    // For example, using the Chat GPT API endpoint:
    // POST https://api.openai.com/v1/chat/completions

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    // Adjust the prompt or messages to produce an affirmation
    final body = json.encode({
      "model": "gpt-4o",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a helpful assistant that creates short, positive affirmations for users."
        },
        {
          "role": "user",
          "content":
              "Please provide a brief, uplifting, and personalized affirmation for my day."
        }
      ],
      "temperature": 0.7,
      "max_tokens": 60
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // "choices" -> first choice -> "message" -> "content"
      final completion = data['choices'][0]['message']['content'];
      return completion.trim();
    } else {
      throw Exception('Failed to generate affirmation. Status: ${response.statusCode}');
    }
  }
}
