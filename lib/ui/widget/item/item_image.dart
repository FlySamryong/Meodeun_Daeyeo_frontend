import 'package:flutter/material.dart';

// 물품 사진 위젯, 추후 구현 예정
class ItemImageWidget extends StatelessWidget {
  const ItemImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Text('물품 사진')),
    );
  }
}
