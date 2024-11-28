import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../service/rent/rent_service.dart';
import '../../../utils/show_error_dialog.dart';
import 'chat_message.dart';
import 'chat_page.dart';
import 'dialog/date_input_dialog.dart';

/// 채팅 메시지 리스트 위젯
class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final int? roomId;
  final int? rentId;
  final int? currentUserId;
  final int? ownerId;

  const ChatMessageList({
    required this.messages,
    required this.scrollController,
    this.roomId,
    this.rentId,
    required this.currentUserId,
    required this.ownerId,
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
        final isFirstMessageOfDay = _isFirstMessageOfDay(index);

        return Column(
          children: [
            if (isFirstMessageOfDay) _buildDateHeader(message.createdAt),
            _buildMessage(context, message),
          ],
        );
      },
    );
  }

  /// 날짜 헤더 위젯 생성
  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        DateFormat("yyyy년 MM월 dd일").format(date),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 메시지 카드와 시간 위젯 생성
  Widget _buildMessage(BuildContext context, ChatMessage message) {
    return Align(
      alignment:
          message.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _buildMessageCard(context, message),
          _buildMessageTime(message.createdAt),
        ],
      ),
    );
  }

  /// 메시지 시간 위젯 생성
  Widget _buildMessageTime(DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        DateFormat("HH:mm").format(time),
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  /// 메시지 카드 생성 (타입에 따라 다르게 처리)
  Widget _buildMessageCard(BuildContext context, ChatMessage message) {
    switch (message.type) {
      case ChatType.RENT_REQ:
        return _buildRequestCard(
            context, message.content, roomId!, message.rentId);
      case ChatType.RENT_ACCEPT:
        return _buildAcceptanceCard(context, message.content);
      case ChatType.RENT_AGREE:
        return _buildInfoCard(
          icon: Icons.assignment_turned_in,
          title: "대여 최종 동의",
          message: message.content,
          backgroundColor: Colors.blue,
        );
      case ChatType.DEPOSIT_REQ:
        return _buildInfoCard(
          icon: Icons.timer,
          title: "보증금 반환 요청",
          message: message.content,
          backgroundColor: Colors.orange,
        );
      case ChatType.OVERDUE:
        return _buildInfoCard(
          icon: Icons.warning,
          title: "연체료 부과 알림",
          message: message.content,
          backgroundColor: Colors.red,
        );
      case ChatType.DEPOSIT_RES:
      case ChatType.CANCEL:
      case ChatType.NOTICE:
        return _buildInfoCard(
          icon: Icons.info,
          title: "알림",
          message: message.content,
          backgroundColor: Colors.green,
        );
      default:
        return _buildTextMessageCard(message.content, message.isSender);
    }
  }

  /// 대여 요청 카드
  Widget _buildRequestCard(
      BuildContext context, String content, int roomId, int? rentId) {
    final isOwner = currentUserId == ownerId;

    return _buildCardTemplate(
      icon: Icons.attach_money,
      title: "대여 요청",
      backgroundColor: const Color(0xFF079702),
      messageWidgets: [
        Text(content, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        if (isOwner && rentId != null)
          _buildActionButton(
            context: context,
            label: "대여 수락하기",
            backgroundColor: const Color(0xFF079702),
            onPressed: () => _showDateInputDialog(context, roomId, rentId),
          ),
      ],
    );
  }

  /// 대여 수락 카드
  Widget _buildAcceptanceCard(BuildContext context, String content) {
    final isNotOwner = currentUserId != ownerId;

    return _buildCardTemplate(
      icon: Icons.check_circle,
      title: "대여 수락",
      backgroundColor: Colors.lightBlue.shade600,
      messageWidgets: [
        Text(content, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        if (isNotOwner)
          _buildActionButton(
            context: context,
            label: "대여 최종 동의하기",
            backgroundColor: Colors.lightBlue.shade600,
            onPressed: () async {
              try {
                await RentService().finalizeRent(
                  context: context,
                  roomId: roomId!,
                  rentId: rentId!,
                );
              } catch (e) {
                showErrorDialog(context, '오류 발생: $e');
              }
            },
          ),
      ],
    );
  }

  /// 정보 카드 생성
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    return _buildCardTemplate(
      icon: icon,
      title: title,
      backgroundColor: backgroundColor,
      messageWidgets: [
        Text(message, style: const TextStyle(fontSize: 14)),
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
      child: FractionallySizedBox(
        widthFactor: 0.6,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: backgroundColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(icon, title, backgroundColor),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: messageWidgets),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 카드 헤더 생성
  Widget _buildCardHeader(IconData icon, String title, Color backgroundColor) {
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

  /// 일반 텍스트 메시지 카드
  Widget _buildTextMessageCard(String content, bool isSender) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: _messageCardDecoration(isSender),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          color: isSender ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  /// 메시지 카드 배경 스타일
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

  /// 날짜 입력 다이얼로그 표시
  void _showDateInputDialog(BuildContext context, int roomId, int rentId) {
    showDialog(
      context: context,
      builder: (context) => DateInputDialog(roomId: roomId, rentId: rentId),
    );
  }

  /// 첫 메시지의 날짜인지 확인
  bool _isFirstMessageOfDay(int index) {
    if (index == messages.length - 1) return true;
    final currentDate = messages[index].createdAt;
    final previousDate = messages[index + 1].createdAt;
    return currentDate.year != previousDate.year ||
        currentDate.month != previousDate.month ||
        currentDate.day != previousDate.day;
  }

  /// 공통 버튼 생성
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
