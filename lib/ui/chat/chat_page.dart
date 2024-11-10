import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../widget/chat_message/appbar.dart';
import '../widget/chat_message/chat_message_list.dart';
import '../widget/chat_message/message_input_field.dart';

// 채팅 메시지 타입
enum ChatType {
  text,
  request,
  acceptance,
  finalAgreement,
  returnReminder,
  lateFeeNotification
}

// 채팅 메시지 클래스
class ChatMessage {
  final String content;
  final ChatType type;
  final bool isSender; // 본인이 보낸 메시지인지 여부

  ChatMessage({
    required this.content,
    required this.type,
    required this.isSender,
  });
}

// 채팅 페이지
class ChatPage extends StatefulWidget {
  final SizingInformation sizingInformation;

  const ChatPage({required this.sizingInformation, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isRenter = false; // 테스트 목적으로 true로 설정 (필요에 따라 변경)

  // 메시지 타입별 콘텐츠 매핑
  final Map<ChatType, String> _chatTypeMessages = {
    ChatType.request: '대여 요청이 수신되었습니다. 12시간 내로 확인해주세요.',
    ChatType.acceptance: '대여 요청이 수락되었습니다. 대여 절차를 진행하세요.',
    ChatType.finalAgreement: '대여가 최종 확정되었습니다. 일정에 따라 이용해주세요.',
    ChatType.returnReminder: '반납까지 2시간 남았습니다. 반납 준비 부탁드립니다.',
    ChatType.lateFeeNotification: '반납 기한이 초과되어 연체료가 부과됩니다.',
  };

  // UI 비율 조정 기준 상수
  static const double baseWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (widget.sizingInformation.screenSize.width / baseWidth).clamp(0.8, 1.2);

    return Scaffold(
      body: Center(
        child: Container(
          width: baseWidth * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const ChatAppBar(),
              const SizedBox(height: 10),
              Expanded(
                child: ChatMessageList(
                  messages: _messages,
                  scrollController: _scrollController,
                ),
              ),
              MessageInputField(
                messageController: _messageController,
                onSendMessage: () => _sendMessage(),
                isSender: true,
                isRenter: isRenter,
              ),
              _buildChatTypeButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // 일반 텍스트 메시지 전송 메서드
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _addMessage(
        content: _messageController.text,
        type: ChatType.text,
        isSender: true,
      );
      _messageController.clear();
    }
  }

  // 특정 타입 메시지 전송 메서드
  void _sendSpecificMessage(ChatType type) {
    final isSender = _determineSender(type);
    final content = _chatTypeMessages[type] ?? '알 수 없는 메시지 타입입니다.';
    _addMessage(content: content, type: type, isSender: isSender);
  }

  // 메시지 추가 및 스크롤 이동 메서드
  void _addMessage({
    required String content,
    required ChatType type,
    required bool isSender,
  }) {
    setState(() {
      _messages.insert(0, ChatMessage(content: content, type: type, isSender: isSender));
    });
    _scrollToBottom();
  }

  // 메시지 타입에 따른 발신자 결정
  bool _determineSender(ChatType type) {
    return (type == ChatType.request || type == ChatType.finalAgreement) ? isRenter : !isRenter;
  }

  // 스크롤을 하단으로 이동
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 메시지 타입별 버튼 생성
  Widget _buildChatTypeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ChatType.values
          .where((type) => type != ChatType.text)
          .map((type) => IconButton(
                icon: Icon(_iconForType(type), color: _colorForType(type)),
                onPressed: () => _sendSpecificMessage(type),
              ))
          .toList(),
    );
  }

  // 각 메시지 타입에 따른 아이콘 설정
  IconData _iconForType(ChatType type) {
    switch (type) {
      case ChatType.request:
        return Icons.request_page;
      case ChatType.acceptance:
        return Icons.check;
      case ChatType.finalAgreement:
        return Icons.assignment_turned_in;
      case ChatType.returnReminder:
        return Icons.timer;
      case ChatType.lateFeeNotification:
        return Icons.warning;
      default:
        return Icons.message;
    }
  }

  // 각 메시지 타입에 따른 아이콘 색상 설정
  Color _colorForType(ChatType type) {
    switch (type) {
      case ChatType.request:
        return Colors.orange;
      case ChatType.acceptance:
        return Colors.green;
      case ChatType.finalAgreement:
        return Colors.blue;
      case ChatType.returnReminder:
        return Colors.redAccent;
      case ChatType.lateFeeNotification:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
