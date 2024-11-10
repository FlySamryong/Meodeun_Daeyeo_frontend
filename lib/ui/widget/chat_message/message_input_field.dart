import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/widget/chat_message/return_code_dialog.dart';
import 'package:meodeundaeyeo/ui/widget/chat_message/return_verification_dialog.dart';
import 'amount_dialog.dart';
import 'message_popup_menu.dart';

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
        if (_showMenu)
          Align(
            alignment: Alignment.centerLeft,
            child: MessagePopupMenu(
              isRenter: widget.isSender,
              onSendAmount: () =>
                  _showDialog(AmountDialog(controller: _amountController)),
              onVerifyReturn: () => _showDialog(
                  ReturnVerificationDialog(controller: _returnCodeController)),
              onGenerateReturnCode: () =>
                  _showDialog(ReturnCodeDialog(generatedCode: '123456')),
              onRequestDepositReturn: () => {},
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
                    _showMenu = !_showMenu;
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

  void _showDialog(Widget dialogContent) {
    showDialog(
      context: context,
      builder: (context) => dialogContent,
    );
  }
}
