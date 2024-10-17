import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../action/chat_nav_action.dart';
import '../../action/favorite_nav_action.dart';
import '../../action/home_nav_action.dart';
import '../../action/mypage_nav_action.dart';
import '../widget/app_title.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/item_register/form_content.dart';

// 물품 등록 페이지
class ItemRegisterPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const ItemRegisterPage({required this.sizingInformation, super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (sizingInformation.screenSize.width / 360).clamp(0.8, 1.2);
    return Scaffold(
      body: Center(
        child: Container(
          width: 360 * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppTitle(title: '물품 등록'),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: FormContentWidget(scaleWidth: scaleWidth),
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
