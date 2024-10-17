import 'package:flutter/material.dart';

// 아이콘 버튼 위젯
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
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }
}
