import 'package:flutter/material.dart';

// 대여 내역 아이템 위젯
class RentalHistoryItemWidget extends StatelessWidget {
  final String title;
  final String location;
  final String period;
  final String status;

  const RentalHistoryItemWidget({
    required this.title,
    required this.location,
    required this.period,
    required this.status,
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
        child: Stack(
          children: [
            Row(
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
                    Text('대여 장소: $location'),
                    const SizedBox(height: 5),
                    Text('대여 기간: $period'),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: _buildStatusBadge(status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String displayText;

    switch (status) {
      case '반납완료':
        badgeColor = Color(0xFF079702).withOpacity(0.95);
        displayText = '반납완료';
        break;
      case '대여중':
        badgeColor = Colors.orange;
        displayText = '대여중';
        break;
      case '연체중':
        badgeColor = Colors.red;
        displayText = '연체중';
        break;
      default:
        badgeColor = Colors.grey;
        displayText = '상태 없음';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
