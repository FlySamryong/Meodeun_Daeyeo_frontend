import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../action/chat_nav_action.dart';
import '../../action/favorite_nav_action.dart';
import '../../action/home_nav_action.dart';
import '../../action/mypage_nav_action.dart';
import '../widget/app_title.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/mypage/recently_view_list.dart';

// 최근 본 아이템 페이지
class RecentlyViewedPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const RecentlyViewedPage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context) {
    final double baseWidth = 360;
    final double scaleWidth =
        (sizingInformation.screenSize.width / baseWidth).clamp(0.8, 1.2);

    return Scaffold(
      body: Center(
        child: Container(
          width: baseWidth * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppTitle(title: '최근 본 아이템'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 20),
                      RecentlyViewedListWidget(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              BottomNavBar(
                homeAction: HomeNavAction(sizingInformation),
                favoritesAction: FavoriteNavAction(sizingInformation),
                chatAction: ChatNavAction(sizingInformation),
                profileAction: MyPageNavAction(sizingInformation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
