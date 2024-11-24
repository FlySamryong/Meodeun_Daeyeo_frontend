import 'package:flutter/material.dart';

/// 물품 설명 필드 위젯
class DescriptionFieldWidget extends StatelessWidget {
  final double scaleWidth;
  final TextEditingController? controller; // 컨트롤러 추가

  const DescriptionFieldWidget({
    required this.scaleWidth,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10 * scaleWidth),
      decoration: _buildContainerDecoration(),
      child: TextField(
        controller: controller, // 컨트롤러 추가
        maxLines: 5,
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
      labelText: '물품에 대한 자세한 설명',
      labelStyle: TextStyle(
        fontFamily: 'BM Dohyeon',
        color: Colors.black,
        fontSize: 14 * scaleWidth,
      ),
      border: InputBorder.none,
    );
  }
}