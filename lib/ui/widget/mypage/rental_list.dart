import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/widget/mypage/rental_history_item.dart';

// 대여 내역 목록 위젯, 추후 API 연동 시 수정 필요
class RentalListWidget extends StatelessWidget {
  const RentalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        // 예시 상태 값
        String status;
        if (index % 3 == 0) {
          status = '반납완료';
        } else if (index % 3 == 1) {
          status = '대여중';
        } else {
          status = '연체중';
        }

        return RentalHistoryItemWidget(
          title: '아이템 $index',
          location: '서울',
          period: '2024-10-01 ~ 2024-10-10',
          status: status,
        );
      },
    );
  }
}
