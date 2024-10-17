import 'package:flutter/material.dart';

// 필터 버튼 위젯, 거주지, 카테고리, 정렬 버튼에 사용
class FilterButtonWidget extends StatelessWidget {
  final String label;
  final double width;
  final VoidCallback onPressed;

  const FilterButtonWidget({
    required this.label,
    required this.width,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 30,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: const Color(0xFF079702)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'BM Dohyeon',
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
