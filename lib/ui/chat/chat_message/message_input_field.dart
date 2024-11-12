import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/chat/chat_message/dialog/return_code_dialog.dart';
import 'package:meodeundaeyeo/ui/chat/chat_message/dialog/return_verification_dialog.dart';
import 'dialog/amount_dialog.dart';
import 'popup_menu/message_popup_menu.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final bool isSender;
  final bool isRenter;

  const MessageInputField({
    required this.messageController,
    required this.onSendMessage,
    required this.isSender,
    required this.isRenter,
    super.key,
  });

  @override
  _MessageInputFieldState createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  bool _showMenu = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _returnCodeController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _returnCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showMenu) _buildMessagePopupMenu(),
        const SizedBox(height: 10),
        _buildMessageInputField(),
      ],
    );
  }

  /// 메뉴 토글 버튼 및 팝업 메뉴 생성
  Widget _buildMessagePopupMenu() {
    return Align(
      alignment: Alignment.centerLeft,
      child: MessagePopupMenu(
        isRenter: widget.isSender,
        onSendAmount: () => _showDialog(AmountDialog(controller: _amountController)),
        onVerifyReturn: () => _showDialog(ReturnVerificationDialog(controller: _returnCodeController)),
        onGenerateReturnCode: () => _showDialog(ReturnCodeDialog(generatedCode: '123456')),
        onRequestDepositReturn: () => {},
      ),
    );
  }

  /// 메시지 입력 필드 UI 구성
  Widget _buildMessageInputField() {
    return Container(
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
            onPressed: _toggleMenu,
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
    );
  }

  /// 다이얼로그를 표시하는 함수
  void _showDialog(Widget dialogContent) {
    showDialog(
      context: context,
      builder: (context) => dialogContent,
    );
  }

  /// 메뉴 토글 함수
  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }
}
