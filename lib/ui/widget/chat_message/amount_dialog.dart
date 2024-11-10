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
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: '금액을 입력하세요',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
