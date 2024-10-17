import 'package:flutter/material.dart';
import 'item_detail_text.dart';
import 'item_image.dart';

// 물품 상세 정보 박스 위젯
class ItemDetailBoxWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ItemDetailBoxWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ItemImageWidget(),
          const SizedBox(height: 20),
          _buildDescriptionBox(),
          const SizedBox(height: 20),
          DetailTextWidget(text: '대여 가능 여부: ${data['available']}'),
          const SizedBox(height: 10),
          DetailTextWidget(text: '1일 대여료: ${data['rental_price']}원'),
          const SizedBox(height: 10),
          DetailTextWidget(text: '보증금: ${data['deposit']}원'),
          const SizedBox(height: 10),
          DetailTextWidget(text: '거래 장소: ${data['location']}'),
          const SizedBox(height: 10),
          DetailTextWidget(text: '대여 가능 기간: ${data['rental_period']}'),
        ],
      ),
    );
  }

  // 설명 박스를 만드는 메서드
  Widget _buildDescriptionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Text(
        data['description'],
        style: const TextStyle(
          fontFamily: 'BM Dohyeon',
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
