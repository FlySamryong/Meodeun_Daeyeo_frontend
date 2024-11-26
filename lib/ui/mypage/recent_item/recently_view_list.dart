import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../service/member/member_service.dart';
import '../../../utils/show_error_dialog.dart';
import '../../item/detail/item_detail_page.dart';
import 'recently_view_item.dart';

/// 최근 본 물품 목록 위젯
class RecentlyViewedListWidget extends StatefulWidget {
  final SizingInformation sizingInformation;

  const RecentlyViewedListWidget({super.key, required this.sizingInformation});

  @override
  State<RecentlyViewedListWidget> createState() =>
      _RecentlyViewedListWidgetState();
}

class _RecentlyViewedListWidgetState extends State<RecentlyViewedListWidget> {
  final MemberService _recentViewItemService = MemberService();
  late Future<List<Map<String, dynamic>>> _recentItems;

  bool _hasShownErrorDialog = false; // 오류 다이얼로그가 이미 표시되었는지 확인

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
          // 오류가 발생했을 때만 다이얼로그 표시
          if (!_hasShownErrorDialog) {
            _hasShownErrorDialog = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(context, snapshot.error.toString());
            });
          }
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
                location:
                    '${item['location']['city']} ${item['location']['district']} ${item['location']['neighborhood']}',
                categories: _extractCategories(item['categoryList']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(
                        sizingInformation: widget.sizingInformation,
                        itemId: item['itemId'], // 전달할 itemId
                      ),
                    ),
                  );
                },
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
