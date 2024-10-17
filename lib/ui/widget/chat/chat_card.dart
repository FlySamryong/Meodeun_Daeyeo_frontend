import 'package:flutter/material.dart';

// 채팅 카드 위젯
class ChatCard extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatCard({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildChatImage(),
            const SizedBox(width: 20),
            _buildChatInfo(),
            _buildChatTime(chat['lastMessageTime']),
          ],
        ),
      ),
    );
  }

  Widget _buildChatImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Center(child: Text('프로필')),
    );
  }

  Widget _buildChatInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chat['chatPartner'],
            style: const TextStyle(
              fontFamily: 'BM Dohyeon',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            chat['lastMessage'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChatTime(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
