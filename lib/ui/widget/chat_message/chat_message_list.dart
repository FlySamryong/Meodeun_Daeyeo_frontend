import 'package:flutter/material.dart';

// 채팅 메시지 리스트
class ChatMessageList extends StatelessWidget {
  final List<String> messages;

  const ChatMessageList({required this.messages, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: index % 2 == 0
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Colors.grey.shade300
                    : const Color(0xFF079702).withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft:
                      index % 2 == 0 ? Radius.zero : Radius.circular(16),
                  bottomRight:
                      index % 2 == 0 ? Radius.circular(16) : Radius.zero,
                ),
              ),
              child: Text(
                messages[index],
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'BM Dohyeon',
                  color:
                      index % 2 == 0 ? const Color(0xFF079702) : Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '오후 7:24', // 고정된 메시지 시간, 추후 수정 필요
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'BM Dohyeon',
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
