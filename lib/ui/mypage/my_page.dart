import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/mypage/recent_view_item_page.dart';
import 'package:meodeundaeyeo/ui/mypage/rental_history_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../action/chat_nav_action.dart';
import '../../action/favorite_nav_action.dart';
import '../../action/home_nav_action.dart';
import '../../action/mypage_nav_action.dart';
import '../widget/app_title.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/mypage/profile_section.dart';
import '../widget/mypage/section.dart';

// 마이 페이지
class MyPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const MyPage({super.key, required this.sizingInformation});

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
              const AppTitle(title: '마이페이지'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const ProfileSectionWidget(),
                      const SizedBox(height: 30),
                      SectionWidget(
                        title: '진행중인 대여 목록',
                        icon: Icons.arrow_forward,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResponsiveBuilder(
                                builder: (context, sizingInformation) {
                                  return Scaffold(
                                    body: Center(
                                      child: RentalHistoryPage(
                                        sizingInformation: sizingInformation,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      SectionWidget(
                        title: '최근 조회한 물품 목록',
                        icon: Icons.arrow_forward,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResponsiveBuilder(
                                builder: (context, sizingInformation) {
                                  return Scaffold(
                                    body: Center(
                                      child: RecentlyViewedPage(
                                        sizingInformation: sizingInformation,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      SectionWidget(
                        title: '고객센터',
                        icon: Icons.arrow_forward,
                        onTap: () {
                          // 고객센터 페이지로 이동 (페이지 추가 필요)
                        },
                      ),
                      const SizedBox(height: 30),
                      SectionWidget(
                        title: '이용 약관',
                        icon: Icons.arrow_forward,
                        onTap: () {
                          // 이용 약관 페이지로 이동 (페이지 추가 필요)
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              BottomNavBar(
                homeAction: HomeNavAction(sizingInformation),
                favoritesAction: FavoriteNavAction(sizingInformation),
                chatAction: ChatNavAction(sizingInformation),
                profileAction: MyPageNavAction(sizingInformation),
              )
            ],
          ),
        ),
      ),
    );
  }
}
