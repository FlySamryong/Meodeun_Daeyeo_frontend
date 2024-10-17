import 'package:flutter/material.dart';

// 섹션 위젯
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'BM Dohyeon',
              ),
            ),
            Icon(
              icon,
              color: const Color(0xFF079702),
            ),
          ],
        ),
      ),
    );
  }
}
