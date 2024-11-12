import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_dialog.dart';

class AmountDialog extends StatelessWidget {
  final TextEditingController controller;

  const AmountDialog({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '송금하기',
      content: _buildAmountInputField(), // 금액 입력 필드 위젯 분리
    );
  }

  /// 금액 입력 필드를 생성하는 함수
  Widget _buildAmountInputField() {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: '금액을 입력하세요',
        border: InputBorder.none,
      ),
    );
  }
}
