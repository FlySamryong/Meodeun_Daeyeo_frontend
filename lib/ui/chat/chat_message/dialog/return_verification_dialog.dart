import 'package:flutter/material.dart';
import '../../../../service/rent/rent_service.dart';
import '../../../../utils/show_error_dialog.dart';

/// 반납 인증 다이얼로그
class ReturnVerificationDialog extends StatefulWidget {
  final TextEditingController controller;
  final int roomId;
  final int rentId;

  const ReturnVerificationDialog({
    required this.controller,
    required this.roomId,
    required this.rentId,
    Key? key,
  }) : super(key: key);

  @override
  _ReturnVerificationDialogState createState() =>
      _ReturnVerificationDialogState();
}

class _ReturnVerificationDialogState extends State<ReturnVerificationDialog> {
  bool _isLoading = false;

  /// 인증 번호 확인 메서드
  Future<void> _verifyOtp() async {
    if (widget.controller.text.trim().isEmpty) {
      showErrorDialog(context, "인증 번호를 입력해주세요.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await RentService().verifyOtp(
        context: context,
        roomId: widget.roomId,
        rentId: widget.rentId,
        otp: widget.controller.text,
      );
      Navigator.of(context).pop(); // 다이얼로그 닫기
    } catch (e) {
      showErrorDialog(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: _dialogBoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 10),
            _buildVerificationTextField(),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 20),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  /// 다이얼로그 박스 스타일
  BoxDecoration _dialogBoxDecoration() {
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

  /// 다이얼로그 제목
  Widget _buildTitle() {
    return const Text(
      '반납 인증하기',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF079702),
      ),
    );
  }

  /// 인증 번호 입력 필드
  Widget _buildVerificationTextField() {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration('인증 번호를 입력하세요'),
    );
  }

  /// 공통 입력 필드 스타일
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF079702)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF079702)),
      ),
    );
  }

  /// 확인 버튼
  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _verifyOtp,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF079702),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        '확인',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
