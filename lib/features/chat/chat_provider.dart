import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';

 import 'ai_service.dart';
 import '../../models/chat_message.dart';


class ChatProvider extends ChangeNotifier {
  final AiService aiService;

  List<ChatMessage> messages = [];
  bool isLoading = false;

  ChatProvider(this.aiService);

  Future<void> sendMessage(String text) async {
    messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    isLoading = true;
    notifyListeners();

    try {
      final reply = await aiService.sendMessage(text);

      messages.add(ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      messages.add(ChatMessage(
        text: "Ошибка. Попробуйте снова.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    isLoading = false;
    notifyListeners();
  }
}
