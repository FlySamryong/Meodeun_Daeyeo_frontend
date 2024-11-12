import 'package:flutter/cupertino.dart';
import 'package:meodeundaeyeo/ui/chat/chat_message/popup_menu/popup_menu_item.dart';

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
          _buildPopupMenuItem(
            text: '송금하기',
            onTap: onSendAmount,
          ),
          const SizedBox(width: 10),
          _buildPopupMenuItem(
            text: '반납 인증번호 누르기',
            onTap: onVerifyReturn,
          ),
        ] else ...[
          _buildPopupMenuItem(
            text: '반납 진행하기',
            onTap: onGenerateReturnCode,
          ),
          const SizedBox(width: 10),
          _buildPopupMenuItem(
            text: '보증금 반환하기',
            onTap: onRequestDepositReturn,
          ),
        ],
      ],
    );
  }

  /// 공통된 PopupMenuItemWidget을 반환하는 함수
  Widget _buildPopupMenuItem({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: PopupMenuItemWidget(
        text: text,
        color: const Color(0xFF079702),
      ),
    );
  }
}
