import 'package:flutter/material.dart';

/// 섹션 위젯
class SectionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SectionWidget({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitle(),
            _buildIcon(),
          ],
        ),
      ),
    );
  }

  /// 제목을 빌드하는 함수
  Widget _buildTitle() {
    return Text(
      title,
      style: _textStyle(),
    );
  }

  /// 아이콘을 빌드하는 함수
  Widget _buildIcon() {
    return Icon(
      icon,
      color: const Color(0xFF079702),
    );
  }

  /// 텍스트 스타일을 반환하는 함수
  TextStyle _textStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: 'BM Dohyeon',
    );
  }
}
