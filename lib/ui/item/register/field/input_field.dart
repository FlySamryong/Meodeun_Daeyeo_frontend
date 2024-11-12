import 'package:flutter/material.dart';

/// 입력 필드 위젯
class InputFieldWidget extends StatelessWidget {
  final String labelText;
  final double scaleWidth;

  const InputFieldWidget({
    required this.labelText,
    required this.scaleWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleWidth),
      decoration: _buildContainerDecoration(),
      child: TextField(
        decoration: _buildInputDecoration(),
      ),
    );
  }

  /// 컨테이너 장식 스타일을 반환하는 함수
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5 * scaleWidth),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  /// 텍스트 필드의 InputDecoration을 반환하는 함수
  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        fontFamily: 'BM Dohyeon',
        color: Colors.black,
        fontSize: 14 * scaleWidth,
      ),
      border: InputBorder.none,
    );
  }
}
