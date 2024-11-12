import 'package:flutter/material.dart';

/// 제출 버튼 위젯
class SubmitButtonWidget extends StatelessWidget {
  final double scaleWidth;

  const SubmitButtonWidget({required this.scaleWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 제출 로직 처리
      },
      style: _buttonStyle(),
      child: _buttonText(),
    );
  }

  /// 버튼 스타일을 반환하는 함수
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        vertical: 15 * scaleWidth,
        horizontal: 50 * scaleWidth,
      ),
      backgroundColor: const Color(0xFF079702).withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10 * scaleWidth),
      ),
    );
  }

  /// 버튼 텍스트를 반환하는 함수
  Widget _buttonText() {
    return Text(
      '등록하기',
      style: TextStyle(
        fontFamily: 'BM Dohyeon',
        fontSize: 16 * scaleWidth,
        color: Colors.white,
      ),
    );
  }
}
