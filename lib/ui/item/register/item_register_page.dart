import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import 'form_content.dart';

// 물품 등록 페이지
class ItemRegisterPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const ItemRegisterPage({required this.sizingInformation, super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (sizingInformation.screenSize.width / 400).clamp(1.0, 1.5);
    return Scaffold(
      body: Center(
        child: Container(
          width: 400 * scaleWidth,
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
