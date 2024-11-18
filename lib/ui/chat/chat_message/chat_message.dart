import 'dart:convert';
import 'chat_page.dart';

class ChatMessage {
  final String content;
  final ChatType type;
  final bool isSender;
  final DateTime createdAt;

  ChatMessage({
    required this.content,
    required this.type,
    required this.isSender,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    return ChatMessage(
      content: _decodeMessage(json['message']),
      type: ChatType.values.firstWhere(
        (e) => e.toString() == 'ChatType.${json['type']}',
        orElse: () => ChatType.TEXT,
      ),
      isSender: json['senderId'] == currentUserId,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static String _decodeMessage(String message) {
    try {
      return utf8.decode(message.codeUnits);
    } catch (e) {
      return message;
    }
  }
}
