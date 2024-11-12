import 'package:flutter/material.dart';
import 'chat_page.dart';

// 채팅 메시지 리스트
class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const ChatMessageList({
    required this.messages,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessage(message);
      },
    );
  }

  /// 메시지 빌드 함수
  Widget _buildMessage(ChatMessage message) {
    final Widget messageCard = _buildMessageCard(message);

    /// 메시지 타입에 따라 왼쪽(상대방)과 오른쪽(본인) 정렬 설정
    return Align(
      alignment: message.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          messageCard,
          _buildMessageTime(),
        ],
      ),
    );
  }

  /// 메시지 타입에 따라 카드 빌드
  Widget _buildMessageCard(ChatMessage message) {
    switch (message.type) {
      case ChatType.RENT_REQ:
        return _buildRequestCard();
      case ChatType.RENT_ACCEPT:
        return _buildAcceptanceCard();
      case ChatType.RENT_AGREE:
        return _buildInfoCard(
          icon: Icons.assignment_turned_in,
          title: "대여 최종 동의",
          message: "대여가 최종 확정되었습니다. 일정에 따라 이용해주세요.",
          backgroundColor: Colors.blue,
        );
      case ChatType.DEPOSIT_REQ:
        return _buildInfoCard(
          icon: Icons.timer,
          title: "반납 남은 기간 알림",
          message: "반납까지 2시간 남았습니다. 반납 준비 부탁드립니다.",
          backgroundColor: Colors.orange,
        );
      case ChatType.OVERDUE:
        return _buildInfoCard(
          icon: Icons.warning,
          title: "연체료 부과 알림",
          message: "반납 기한이 초과되었습니다. 연체료가 부과됩니다.",
          backgroundColor: Colors.red,
        );
      default:
        return _buildTextMessageCard(message.content, message.isSender);
    }
  }

  /// 공통 텍스트 메시지 카드 빌더
  Widget _buildTextMessageCard(String content, bool isSender) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: _messageCardDecoration(isSender),
      child: Text(
        content,
        style: _messageTextStyle(isSender),
      ),
    );
  }

  /// 공통 메시지 카드 장식
  BoxDecoration _messageCardDecoration(bool isSender) {
    return BoxDecoration(
      color: isSender ? const Color(0xFF079702) : Colors.grey.shade200,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: isSender ? const Radius.circular(12) : Radius.zero,
        bottomRight: isSender ? Radius.zero : const Radius.circular(12),
      ),
    );
  }

  /// 공통 메시지 텍스트 스타일
  TextStyle _messageTextStyle(bool isSender) {
    return TextStyle(
      fontSize: 14,
      fontFamily: 'BM Dohyeon',
      color: isSender ? Colors.white : Colors.black87,
    );
  }

  /// 메시지 카드 공통 템플릿
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: backgroundColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(icon: icon, title: title, backgroundColor: backgroundColor),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(message, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  /// 대여 요청 카드
  Widget _buildRequestCard() {
    return _buildCardTemplate(
      icon: Icons.attach_money,
      title: "대여 요청",
      backgroundColor: const Color(0xFF079702),
      messageWidgets: [
        _buildBoldText("대여료:", "20,000원"),
        _buildBoldText("보증금:", "50,000원"),
        _buildBoldText("대여 기간:", "2024-10-28 ~ 2024-11-03"),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF079702),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              "대여 수락하기",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// 대여 수락 카드
  Widget _buildAcceptanceCard() {
    return _buildCardTemplate(
      icon: Icons.check_circle,
      title: "대여 수락",
      backgroundColor: Colors.lightBlue.shade600,
      messageWidgets: [
        const Text("대여 요청이 수락되었습니다. 대여 절차를 진행하세요.", style: TextStyle(fontSize: 14)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade600,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              "대여 최종 동의하기",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// 공통 카드 템플릿
  Widget _buildCardTemplate({
    required IconData icon,
    required String title,
    required Color backgroundColor,
    required List<Widget> messageWidgets,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: backgroundColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(icon: icon, title: title, backgroundColor: backgroundColor),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: messageWidgets),
            ),
          ],
        ),
      ),
    );
  }

  /// 카드 헤더 공통 템플릿
  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 굵은 텍스트 빌더
  Widget _buildBoldText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: ' $value',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// 메시지 시간 표시
  Widget _buildMessageTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '시간',
        style: TextStyle(
          fontSize: 10,
          fontFamily: 'BM Dohyeon',
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
