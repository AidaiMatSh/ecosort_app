import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("https://your-api.com/chat"), // потом заменишь
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": message,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"];
    } else {
      throw Exception("Ошибка AI");
    }
  }
}
