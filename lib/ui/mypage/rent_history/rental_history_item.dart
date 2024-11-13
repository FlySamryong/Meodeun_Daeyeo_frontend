import 'package:flutter/material.dart';

/// 대여 내역 아이템 위젯
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
        decoration: _buildContainerDecoration(),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItemDetails(),
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

  /// Container의 장식 스타일 반환 함수
  BoxDecoration _buildContainerDecoration() {
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

  /// 대여 아이템 세부 사항 빌드 함수
  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(title, fontWeight: FontWeight.bold),
        const SizedBox(height: 5),
        _buildText('대여 장소: $location'),
        const SizedBox(height: 5),
        _buildText('대여 기간: $period'),
      ],
    );
  }

  /// 상태 배지 빌드 함수
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

  /// 텍스트 스타일을 관리하는 함수
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