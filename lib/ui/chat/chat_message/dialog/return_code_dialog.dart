import 'package:flutter/cupertino.dart';
import 'common_dialog.dart';

/// 반납 인증 번호 다이얼로그
class ReturnCodeDialog extends StatelessWidget {
  final String generatedCode;

  const ReturnCodeDialog({required this.generatedCode, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '반납 인증 번호',
      content: _buildGeneratedCodeText(),
    );
  }

  /// 생성된 인증 번호 텍스트를 반환하는 함수
  Widget _buildGeneratedCodeText() {
    return Text(
      '생성된 인증 번호: $generatedCode',
      style: const TextStyle(fontSize: 16),
    );
  }
}
