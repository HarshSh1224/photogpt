import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GPTUtils {
  static Future<String> getGPTResponse({required String prompt}) async {
    final response = await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${dotenv.env['token']}"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": prompt}
          ]
        }));

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return responseJson['choices'][0]['message']['content'];
  }
}
