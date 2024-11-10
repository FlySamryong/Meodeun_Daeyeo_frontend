import 'package:flutter/cupertino.dart';

import 'common_dialog.dart';

class ReturnCodeDialog extends StatelessWidget {
  final String generatedCode;

  const ReturnCodeDialog({required this.generatedCode, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '반납 인증 번호',
      content: Text('생성된 인증 번호: $generatedCode',
          style: const TextStyle(fontSize: 16)),
    );
  }
}
