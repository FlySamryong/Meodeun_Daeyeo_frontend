import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/utils/date_time_formatter.dart';

/// 채팅 카드 위젯
class ChatCard extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatCard({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: _cardDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChatImage(chat['otherMemberProfile']),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChatInfo(chat['itemName'], chat['lastMessage']),
                  const SizedBox(height: 20),
                  _buildChatTime(chat['updatedDate']), // 오른쪽 하단으로 배치
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 채팅 카드의 데코레이션 설정
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: const Offset(0, 2),
          blurRadius: 5,
        ),
      ],
    );
  }

  /// 프로필 이미지 빌더
  Widget _buildChatImage(String? imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(40),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? const Center(
              child: Text(
                '프로필',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  /// 채팅 정보 빌더 (이름 및 마지막 메시지)
  Widget _buildChatInfo(String? itemName, String? lastMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemName ?? 'Unknown',
          style: const TextStyle(
            fontFamily: 'BM Dohyeon',
            fontSize: 16,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          lastMessage ?? 'No message',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// 마지막 메시지 시간 표시 위젯 (오른쪽 하단 배치)
  Widget _buildChatTime(String? lastMessageTime) {
    return Align(
      alignment: Alignment.bottomRight, // 오른쪽 하단 정렬
      child: Text(
        lastMessageTime != null
            ? DateTimeFormatter.formatToKoreanDateTime(lastMessageTime)
            : '',
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
