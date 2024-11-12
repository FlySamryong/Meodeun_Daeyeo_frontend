import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/mypage/rent_history/rental_history_item.dart';

/// 대여 내역 목록 위젯, 추후 API 연동 시 수정 필요
class RentalListWidget extends StatelessWidget {
  const RentalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // 임의의 데이터 개수
      itemBuilder: (context, index) {
        // 예시 상태 값을 결정
        String status = _getStatusForIndex(index);

        return _buildRentalHistoryItem(index, status);
      },
    );
  }

  /// 상태 값을 결정하는 함수
  String _getStatusForIndex(int index) {
    if (index % 3 == 0) {
      return '반납완료';
    } else if (index % 3 == 1) {
      return '대여중';
    } else {
      return '연체중';
    }
  }

  /// 대여 내역 아이템을 생성하는 함수
  Widget _buildRentalHistoryItem(int index, String status) {
    return RentalHistoryItemWidget(
      title: '아이템 $index',
      location: '서울',
      period: '2024-10-01 ~ 2024-10-10',
      status: status,
    );
  }
}
