import 'package:flutter/material.dart';

/// 팝업 메뉴 아이템 위젯
class PopupMenuItemWidget extends StatelessWidget {
  final String text;
  final Color color;

  const PopupMenuItemWidget({
    required this.text,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: _buildDecoration(),
      child: _buildText(),
    );
  }

  /// Container의 decoration을 빌드하는 함수
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.8)),
    );
  }

  /// Text 스타일을 설정하는 함수
  Widget _buildText() {
    return Text(
      text,
      style: _buildTextStyle(),
    );
  }

  /// Text 스타일을 설정하는 함수
  TextStyle _buildTextStyle() {
    return TextStyle(
      color: color,
      fontFamily: 'BM Dohyeon',
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }
}
