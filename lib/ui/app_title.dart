import 'package:flutter/material.dart';

/// 앱 타이틀 위젯
class AppTitle extends StatelessWidget {
  final String title;

  const AppTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitleText(title),
          _buildTitleText('뭐든 대여', paddingRight: 5),
        ],
      ),
    );
  }

  /// 텍스트 스타일을 반환하는 함수
  Widget _buildTitleText(String text, {double paddingRight = 0}) {
    return Padding(
      padding: EdgeInsets.only(right: paddingRight),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'BM Dohyeon',
          color: Colors.black,
        ),
      ),
    );
  }
}
