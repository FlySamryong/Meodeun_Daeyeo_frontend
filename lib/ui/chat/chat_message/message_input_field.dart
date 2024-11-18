import 'package:flutter/material.dart';
import '../../../service/rent/rent_service.dart';
import '../../../utils/show_error_dialog.dart';
import 'dialog/amount_dialog.dart';
import 'dialog/return_code_dialog.dart';
import 'dialog/return_deposit_dialog.dart';
import 'dialog/return_verification_dialog.dart';
import 'popup_menu/message_popup_menu.dart';

/// 메시지 입력 필드 위젯
class MessageInputField extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final bool isSender;
  final bool isRenter;
  final int roomId;
  final int? rentId;
  final ValueChanged<int> onRentIdUpdated; // rentId 업데이트 콜백 추가

  const MessageInputField({
    required this.messageController,
    required this.onSendMessage,
    required this.isSender,
    required this.isRenter,
    required this.roomId,
    this.rentId,
    required this.onRentIdUpdated,
    Key? key,
  }) : super(key: key);

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
        if (_showMenu) _buildPopupMenu(),
        const SizedBox(height: 10),
        _buildInputField(),
      ],
    );
  }

  /// 팝업 메뉴 위젯
  Widget _buildPopupMenu() {
    return Align(
      alignment: Alignment.centerLeft,
      child: MessagePopupMenu(
        isRenter: widget.isRenter,
        onSendAmount: _showAmountDialog,
        onVerifyReturn: _showReturnVerificationDialog,
        onGenerateReturnCode: _showReturnCodeDialog,
        onRequestDepositReturn: _showReturnDepositDialog,
      ),
    );
  }

  /// 메시지 입력 필드 위젯
  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: _inputFieldDecoration(),
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

  /// 입력 필드 스타일링
  BoxDecoration _inputFieldDecoration() {
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

  /// 금액 입력 다이얼로그 표시
  void _showAmountDialog() {
    _showDialog(
      builder: (context) => AmountDialog(
        controller: _amountController,
        roomId: widget.roomId,
        onRentCreated: widget.onRentIdUpdated,
      ),
    );
  }

  /// 반환 인증 다이얼로그 표시
  void _showReturnVerificationDialog() {
    _showDialogWithRentId(
      builder: (context) => ReturnVerificationDialog(
        controller: _returnCodeController,
        roomId: widget.roomId,
        rentId: widget.rentId!,
      ),
    );
  }

  /// 반환 코드 생성 다이얼로그 표시
  Future<void> _showReturnCodeDialog() async {
    await _executeWithRentId(
      action: () async {
        final otp = await RentService().generateOtp(
          context: context,
          roomId: widget.roomId,
          rentId: widget.rentId!,
        );
        _showDialog(
          builder: (context) => ReturnCodeDialog(generatedCode: otp),
        );
      },
    );
  }

  /// 보증금 반환 다이얼로그 표시
  void _showReturnDepositDialog() {
    _showDialogWithRentId(
      builder: (context) => ReturnDepositDialog(
        roomId: widget.roomId,
        rentId: widget.rentId!,
      ),
    );
  }

  /// 메뉴 표시 여부 토글
  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  /// rentId가 필요한 다이얼로그 표시
  void _showDialogWithRentId({required WidgetBuilder builder}) {
    if (widget.rentId == null) {
      showErrorDialog(context, "대여가 생성되지 않았습니다.");
    } else {
      _showDialog(builder: builder);
    }
  }

  /// rentId가 필요한 작업 실행
  Future<void> _executeWithRentId({required Future<void> Function() action}) async {
    if (widget.rentId == null) {
      showErrorDialog(context, "대여가 생성되지 않았습니다.");
    } else {
      try {
        await action();
      } catch (e) {
        showErrorDialog(context, '오류 발생: $e');
      }
    }
  }

  /// 다이얼로그 표시
  void _showDialog({required WidgetBuilder builder}) {
    showDialog(context: context, builder: builder);
  }
}
