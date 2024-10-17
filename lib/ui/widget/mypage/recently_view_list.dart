import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/item/item_detail_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:meodeundaeyeo/ui/widget/mypage/recently_view_item.dart';

// 최근 본 물품 목록 위젯
class RecentlyViewedListWidget extends StatelessWidget {
  const RecentlyViewedListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // 임의의 데이터 개수
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // 아이템을 클릭하면 상세 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    return ItemDetailScreen(
                      sizingInformation: sizingInformation,
                    );
                  },
                ),
              ),
            );
          },
          child: RecentlyViewedItemWidget(
            title: '아이템 $index',
            price: '5000원',
            period: '5일',
            category: '전자기기',
          ),
        );
      },
    );
  }
}
