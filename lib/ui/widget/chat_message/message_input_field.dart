import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/widget/chat_message/popup_menu_item.dart';

// 메시지 입력 필드 위젯
class MessageInputField extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;

  const MessageInputField({
    required this.messageController,
    required this.onSendMessage,
    super.key,
  });

  @override
  _MessageInputFieldState createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  bool _showMenu = false; // 메뉴 표시 여부를 제어하는 변수

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showMenu)
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMenu = false;
                    });
                    // 송금하기 로직
                  },
                  child: PopupMenuItemWidget(
                    text: '송금하기',
                    color: const Color(0xFF079702),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMenu = false;
                    });
                    // 반납하기 로직
                  },
                  child: PopupMenuItemWidget(
                    text: '반납하기',
                    color: const Color(0xFF079702),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF079702)),
                onPressed: () {
                  setState(() {
                    _showMenu = !_showMenu; // 메뉴 열기/닫기
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: widget.messageController,
                  decoration: const InputDecoration(
                    hintText: '메시지를 입력하세요',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF079702)),
                onPressed: widget.onSendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
