import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/mypage/recent_item/recent_view_item_page.dart';
import 'package:meodeundaeyeo/ui/mypage/rent_history/rental_history_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import '../accout_register/account_registeration_dialog.dart';
import 'profile_section.dart';
import '../section.dart';

/// 마이 페이지
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProfileSectionWidget(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // 계좌 등록하기 버튼
                                OutlinedButton(
                                  onPressed: () =>
                                      _showAccountRegistrationDialog(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: const Text(
                                    "계좌 등록하기",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8), // 버튼 사이 간격
                                // 거주지 등록하기 버튼
                                OutlinedButton(
                                  onPressed: () =>
                                      {}, // 거주지 등록 페이지로 이동 (페이지 추가 필요)
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: const Text(
                                    "거주지 등록하기",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSection(
                        context,
                        '진행중인 대여 목록',
                        Icons.arrow_forward,
                        () => _navigateToPage<RentalHistoryPage>(context),
                      ),
                      const SizedBox(height: 30),
                      _buildSection(
                        context,
                        '최근 조회한 물품 목록',
                        Icons.arrow_forward,
                        () => _navigateToPage<RecentlyViewedPage>(context),
                      ),
                      const SizedBox(height: 30),
                      _buildSection(
                        context,
                        '고객센터',
                        Icons.arrow_forward,
                        () {
                          // 고객센터 페이지로 이동 (페이지 추가 필요)
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildSection(
                        context,
                        '이용 약관',
                        Icons.arrow_forward,
                        () {
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 계좌 등록 다이얼로그 표시 함수
  void _showAccountRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // 계좌 등록 다이얼로그를 호출합니다.
        return AccountRegistrationDialog(parentContext: context);
      },
    );
  }

  /// 섹션 빌드 함수
  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return SectionWidget(
      title: title,
      icon: icon,
      onTap: onTap,
    );
  }

  /// 페이지 네비게이션 함수
  void _navigateToPage<T>(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return Scaffold(
              body: Center(
                child: T == RentalHistoryPage
                    ? RentalHistoryPage(sizingInformation: sizingInformation)
                    : RecentlyViewedPage(sizingInformation: sizingInformation),
              ),
            );
          },
        ),
      ),
    );
  }
}
