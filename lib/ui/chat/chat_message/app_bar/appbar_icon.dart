import 'package:flutter/material.dart';

/// 아이콘 버튼 위젯
class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const IconButtonWidget({
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildIcon(), // 아이콘을 빌드하는 함수로 분리
      onPressed: onPressed,
    );
  }

  /// 아이콘 빌드를 분리하여 코드 재사용성 높이기
  Icon _buildIcon() {
    return Icon(icon, color: color);
  }
}
