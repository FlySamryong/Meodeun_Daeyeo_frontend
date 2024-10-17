import 'package:flutter/material.dart';

// 상세 정보 텍스트 위젯
class DetailTextWidget extends StatelessWidget {
  final String text;

  const DetailTextWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'BM Dohyeon',
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
