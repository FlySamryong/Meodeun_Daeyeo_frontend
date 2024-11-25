import 'package:flutter/material.dart';
import '../../../service/recent_view_item_service.dart';
import 'recently_view_item.dart';

/// 최근 본 물품 목록 위젯
class RecentlyViewedListWidget extends StatefulWidget {
  const RecentlyViewedListWidget({super.key});

  @override
  State<RecentlyViewedListWidget> createState() =>
      _RecentlyViewedListWidgetState();
}

class _RecentlyViewedListWidgetState extends State<RecentlyViewedListWidget> {
  final RecentViewItemService _recentViewItemService = RecentViewItemService();
  late Future<List<Map<String, dynamic>>> _recentItems;

  @override
  void initState() {
    super.initState();
    _recentItems = _recentViewItemService.fetchRecentItems(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _recentItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('최근 본 물품이 없습니다.'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return RecentlyViewedItemWidget(
                title: item['name'],
                price: '${item['fee']}원',
                period: '정보 없음', // 데이터에 없는 경우 기본값
                categories: _extractCategories(item['categoryList']),
              );
            },
          );
        }
      },
    );
  }

  /// 카테고리 목록 추출
  List<String> _extractCategories(List<dynamic>? categoryList) {
    return categoryList?.map((e) => e['name'].toString()).toList() ?? [];
  }
}
