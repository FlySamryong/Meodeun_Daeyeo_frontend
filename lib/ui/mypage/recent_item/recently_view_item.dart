import 'package:flutter/material.dart';

/// 최근 본 물품 위젯
class RecentlyViewedItemWidget extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> categories;

  const RecentlyViewedItemWidget({
    required this.title,
    required this.price,
    required this.period,
    required this.categories,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: _buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildItemDetails(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF079702),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// 박스 스타일
  BoxDecoration _buildBoxDecoration() {
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

  /// 아이템 상세 정보
  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(title, fontWeight: FontWeight.bold),
        const SizedBox(height: 5),
        _buildText('대여료: $price'),
        _buildText('대여 가능 기간: $period'),
        _buildText('카테고리: ${categories.join(", ")}'),
      ],
    );
  }

  /// 텍스트 스타일 적용
  Widget _buildText(String text, {FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: fontWeight,
        fontFamily: 'BM Dohyeon',
      ),
    );
  }
}