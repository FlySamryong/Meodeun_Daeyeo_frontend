import 'package:flutter/material.dart';

// 앱 타이틀 위젯
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'BM Dohyeon',
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 5),
            child: Text(
              '뭐든 대여',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'BM Dohyeon',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
