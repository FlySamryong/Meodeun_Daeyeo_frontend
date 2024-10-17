import 'package:flutter/material.dart';

// 최근 본 물품 위젯
class RecentlyViewedItemWidget extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String category;

  const RecentlyViewedItemWidget({
    required this.title,
    required this.price,
    required this.period,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BM Dohyeon',
                  ),
                ),
                const SizedBox(height: 5),
                Text('대여료: $price'),
                Text('대여가능일자: $period'),
                Text('카테고리: $category'),
              ],
            ),
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
}
