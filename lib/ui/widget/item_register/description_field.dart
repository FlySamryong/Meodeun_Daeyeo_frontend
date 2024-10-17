import 'package:flutter/material.dart';

// 물품 설명 필드 위젯
class DescriptionFieldWidget extends StatelessWidget {
  final double scaleWidth;

  const DescriptionFieldWidget({required this.scaleWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10 * scaleWidth),
      decoration: BoxDecoration(
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
      ),
      child: TextField(
        maxLines: 5,
        decoration: InputDecoration(
          labelText: '물품에 대한 자세한 설명',
          labelStyle: TextStyle(
            fontFamily: 'BM Dohyeon',
            color: Colors.black,
            fontSize: 14 * scaleWidth,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
