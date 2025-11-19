import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import '../api_key.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: "user");
  final _bot = const types.User(id: "bot");

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
  }

  void _showWelcomeMessage() {
    final msg = types.TextMessage(
      author: _bot,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: "Welcome! 👋 How can i help you? 🍳",
    );

    setState(() => _messages.insert(0, msg));
  }

  Future<void> _sendMessageToAI(String text) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openAIKey"
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a smart cooking & food assistant that provides users with recipes, ingredient information, and practical kitchen tips.\n\nYour tasks:\n- Suggest recipes, create new recipes, and explain them step-by-step.\n- Recommend recipes based on available ingredients (e.g., 'I have tomatoes and potatoes, what can I cook?').\n- Give tips on choosing vegetables, fruits, and other foods (e.g., how to pick a ripe watermelon or pineapple).\n- Explain the health benefits of foods (e.g., benefits of broccoli).\n- Provide basic information about healthy eating and nutritional values (calories, protein, etc.).\n- Give refrigerator/freezer storage duration info.\n- Solve common cooking mistakes (e.g., cake didn’t rise, rice turned mushy).\n- Offer ingredient substitutions (e.g., what to use instead of cream).\n- If requested, guide users through recipes step-by-step (user may say 'next step').\n- Create shopping lists for recipes.\n\nRules:\n- If the user asks something unrelated to cooking or food, politely redirect by saying: \"I can help with kitchen and food-related topics 😊\"\n- Keep explanations simple, clear, and easy to understand.\n- Use bullet points when helpful.\n- Adjust explanation depth based on the user's level.\n- When giving recipes, include time, measurements, temperature, and tips if possible.\n- Provide shorter or more detailed versions of recipes upon request.\n- Always aim to add value to the user; avoid unnecessary long messages and stay clear and concise."
          },
          {"role": "user", "content": text}
        ]
      }),
    );

    final data = json.decode(response.body);
    final aiReply = data["choices"][0]["message"]["content"];

    final botMessage = types.TextMessage(
      author: _bot,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: aiReply,
    );

    setState(() => _messages.insert(0, botMessage));
  }

  void _handleSendPressed(types.PartialText message) {
    final userMessage = types.TextMessage(
      author: _user,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    setState(() => _messages.insert(0, userMessage));

    _sendMessageToAI(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Arkaplan beyaz
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Food Assistant 👩‍🍳",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,

        // 🔥 Tema özelleştirme
        theme: DefaultChatTheme(
          backgroundColor: Colors.white,

          // Kullanıcı mesaj balonu (sağ)
          primaryColor: const Color(0xFFB7D4E8),

          // Bot mesaj balonu (sol)
          secondaryColor: const Color(0xFFE5EBF0),

          // Mesaj yazma kutusu
          inputBackgroundColor: const Color(0xFFE7F1F7),

          // Yazı renkleri
          inputTextColor: Colors.black87,
          inputBorderRadius: BorderRadius.circular(20),
          inputTextDecoration: const InputDecoration.collapsed(
            hintText: "Your Message...",
          ),
        ),
      ),
    );
  }
}
