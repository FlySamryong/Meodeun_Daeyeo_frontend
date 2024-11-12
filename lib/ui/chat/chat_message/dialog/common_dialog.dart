import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final Widget content;

  const CommonDialog({required this.title, required this.content, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: _buildDialogContent(context),
    );
  }

  /// 다이얼로그의 콘텐츠를 구성하는 함수
  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: _dialogDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 10),
          content,
          const SizedBox(height: 10),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  /// 다이얼로그의 타이틀을 구성하는 함수
  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF079702),
      ),
    );
  }

  /// 확인 버튼을 구성하는 함수
  Widget _buildConfirmButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        '확인',
        style: TextStyle(color: Color(0xFF079702)),
      ),
    );
  }

  /// 다이얼로그의 장식 스타일을 설정하는 함수
  BoxDecoration _dialogDecoration() {
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
}
