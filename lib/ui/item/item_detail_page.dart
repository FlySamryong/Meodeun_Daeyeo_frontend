import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../action/chat_nav_action.dart';
import '../../action/favorite_nav_action.dart';
import '../../action/home_nav_action.dart';
import '../../action/mypage_nav_action.dart';
import '../widget/app_title.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/item/action_button.dart';
import '../widget/item/item_detail_box.dart';
import '../widget/item/owner_info_box.dart';

class ItemDetailScreen extends StatefulWidget {
  final SizingInformation sizingInformation;

  const ItemDetailScreen({super.key, required this.sizingInformation});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

// 아이템 상세 정보 페이지
class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<Map<String, dynamic>> itemDetails;

  @override
  void initState() {
    super.initState();
    itemDetails = _fetchItemDetails();
  }

  Future<Map<String, dynamic>> _fetchItemDetails() async {
    // 임시 데이터
    return {
      'title': '기본 제목',
      'description': '기본 설명',
      'available': 'N/A',
      'rental_price': '5000',
      'deposit': '10000',
      'location': '서울',
      'lender_nickname': '기본 닉네임',
      'lender_location': '서울',
      'lender_manner_temp': '36.5',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360 *
              (widget.sizingInformation.screenSize.width / 360).clamp(0.8, 1.2),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppTitle(title: '아이템 상세 정보'),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: itemDetails,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Column(
                          children: [
                            ItemDetailBoxWidget(data: data),
                            const SizedBox(height: 20),
                            OwnerInfoBoxWidget(data: data),
                            const SizedBox(height: 20),
                            const ActionButtonsWidget(),
                            const SizedBox(height: 20),
                          ],
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ),
              BottomNavBar(
                homeAction: HomeNavAction(widget.sizingInformation),
                favoritesAction: FavoriteNavAction(widget.sizingInformation),
                chatAction: ChatNavAction(widget.sizingInformation),
                profileAction: MyPageNavAction(widget.sizingInformation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
