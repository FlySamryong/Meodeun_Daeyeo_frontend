import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import 'rental_list.dart';

// 대여 목록 페이지
class RentalHistoryPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const RentalHistoryPage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context) {
    final double scaleWidth = _getScaleWidth();

    return Scaffold(
      body: Center(
        child: Container(
          width: 360 * scaleWidth,
          child: Column(
            children: [
              _buildAppTitle(),
              _buildContent(),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// 화면 크기 비율 계산 함수
  double _getScaleWidth() {
    final double baseWidth = 360;
    return (sizingInformation.screenSize.width / baseWidth).clamp(0.8, 1.2);
  }

  /// 앱 타이틀 빌드 함수
  Widget _buildAppTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: AppTitle(title: '대여 목록'),
    );
  }

  /// 콘텐츠 영역 빌드 함수
  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              RentalListWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 하단 네비게이션 바 빌드 함수
  Widget _buildBottomNavBar() {
    return BottomNavBar(
      homeAction: HomeNavAction(sizingInformation),
      favoritesAction: FavoriteNavAction(sizingInformation),
      chatAction: ChatNavAction(sizingInformation),
      profileAction: MyPageNavAction(sizingInformation),
    );
  }
}
