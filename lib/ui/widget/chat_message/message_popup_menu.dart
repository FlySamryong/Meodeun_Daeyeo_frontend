import 'package:flutter/cupertino.dart';
import 'package:meodeundaeyeo/ui/widget/chat_message/popup_menu_item.dart';

class MessagePopupMenu extends StatelessWidget {
  final bool isRenter;
  final VoidCallback onSendAmount;
  final VoidCallback onVerifyReturn;
  final VoidCallback onGenerateReturnCode;
  final VoidCallback onRequestDepositReturn;

  const MessagePopupMenu({
    required this.isRenter,
    required this.onSendAmount,
    required this.onVerifyReturn,
    required this.onGenerateReturnCode,
    required this.onRequestDepositReturn,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isRenter) ...[
          GestureDetector(
            onTap: onSendAmount,
            child: PopupMenuItemWidget(
              text: '송금하기',
              color: const Color(0xFF079702),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onVerifyReturn,
            child: PopupMenuItemWidget(
              text: '반납 인증번호 누르기',
              color: const Color(0xFF079702),
            ),
          ),
        ] else ...[
          GestureDetector(
            onTap: onGenerateReturnCode,
            child: PopupMenuItemWidget(
              text: '반납 진행하기',
              color: const Color(0xFF079702),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onRequestDepositReturn,
            child: PopupMenuItemWidget(
              text: '보증금 반환하기',
              color: const Color(0xFF079702),
            ),
          ),
        ],
      ],
    );
  }
}
