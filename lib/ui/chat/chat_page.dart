import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../widget/chat_message/appbar.dart';
import '../widget/chat_message/chat_message_list.dart';
import '../widget/chat_message/message_input_field.dart';

// 채팅 페이지
class ChatPage extends StatefulWidget {
  final SizingInformation sizingInformation;

  const ChatPage({required this.sizingInformation, super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (widget.sizingInformation.screenSize.width / 360).clamp(0.8, 1.2);

    return Scaffold(
      body: Center(
        child: Container(
          width: 360 * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const ChatAppBar(),
              const SizedBox(height: 10),
              Expanded(
                child: ChatMessageList(messages: _messages), // 채팅 메시지 리스트
              ),
              MessageInputField(
                messageController: _messageController,
                onSendMessage: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 메시지 전송 메서드
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear(); // 메시지 전송 후 입력 필드 비우기
      });
    }
  }
}
