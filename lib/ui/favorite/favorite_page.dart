import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/action/chat_nav_action.dart';
import 'package:meodeundaeyeo/ui/bottom_nav_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../action/favorite_nav_action.dart';
import '../../action/home_nav_action.dart';
import '../../action/mypage_nav_action.dart';
import '../app_title.dart';
import 'FavoriteItemListWidget.dart';

// 좋아요 목록 페이지
class FavoritesPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const FavoritesPage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context) {
    final double baseWidth = 400;
    final double scaleWidth =
        (sizingInformation.screenSize.width / baseWidth).clamp(1.0, 1.5);

    return Scaffold(
      body: Center(
        child: Container(
          width: baseWidth * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppTitle(title: '좋아요 목록'),
              Expanded(
                child: FavoriteItemListWidget(
                    sizingInformation: sizingInformation),
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
