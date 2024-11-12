import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common_dialog.dart';

class ReturnVerificationDialog extends StatelessWidget {
  final TextEditingController controller;

  const ReturnVerificationDialog({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '반납 인증하기',
      content: _buildVerificationTextField(), // 인증 번호 입력 필드를 별도로 구성
    );
  }

  /// 인증 번호 입력 필드를 반환하는 메서드
  Widget _buildVerificationTextField() {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: '인증 번호를 입력하세요',
        border: InputBorder.none,
      ),
    );
  }
}
