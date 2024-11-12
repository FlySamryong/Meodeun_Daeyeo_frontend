import 'package:flutter/material.dart';
import 'item_detail_text.dart';
import 'item_image.dart';

/// 물품 상세 정보 박스 위젯
class ItemDetailBoxWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ItemDetailBoxWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(),
          const SizedBox(height: 20),
          _buildDescriptionBox(),
          const SizedBox(height: 20),
          _buildDetailText('대여 가능 여부', data['status'] ?? '대여 가능'),
          _buildDetailText('1일 대여료', '${data['fee']}원'),
          _buildDetailText('보증금', '${data['deposit']}원'),
          _buildDetailText(
            '거래 장소',
            '${data['location']['city']} ${data['location']['district']} ${data['location']['neighborhood']}',
          ),
          _buildDetailText('대여 가능 기간', '${data['period']}일'),
        ],
      ),
    );
  }

  /// 박스 스타일을 설정하는 메서드
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: const Offset(0, 2),
          blurRadius: 5,
        ),
      ],
    );
  }

  /// 이미지 캐러셀 위젯
  Widget _buildImageCarousel() {
    return ImageCarouselWidget(imageList: data['imageList'] ?? []);
  }

  /// 설명 박스를 만드는 메서드
  Widget _buildDescriptionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: _descriptionBoxDecoration(),
      child: Text(
        data['description'] ?? '설명 없음', // 설명이 없을 경우 기본값 설정
        style: const TextStyle(
          fontFamily: 'BM Dohyeon',
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// 설명 박스의 스타일을 설정하는 메서드
  BoxDecoration _descriptionBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey.shade300,
      ),
    );
  }

  /// 물품 상세 정보를 표시하는 텍스트 위젯을 생성하는 메서드
  Widget _buildDetailText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DetailTextWidget(text: '$title: $text'),
    );
  }
}
