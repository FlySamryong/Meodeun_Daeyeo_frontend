import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../../service/mypage/mypage_service.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import '../accout_register/account_registeration_dialog.dart';
import '../section.dart';
import 'profile_section.dart';
import '../recent_item/recent_view_item_page.dart';
import '../rent_history/rental_history_page.dart';

/// 마이 페이지
class MyPage extends StatefulWidget {
  final SizingInformation sizingInformation;

  const MyPage({super.key, required this.sizingInformation});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Future<MyPageData> _myPageDataFuture;

  @override
  void initState() {
    super.initState();
    _myPageDataFuture = MyPageService().fetchMyPageData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final double baseWidth = 360;
    final double scaleWidth =
    (widget.sizingInformation.screenSize.width / baseWidth).clamp(0.8, 1.2);

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
                  child: FutureBuilder<MyPageData>(
                    future: _myPageDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('에러 발생: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('데이터 없음'));
                      }

                      final data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          ProfileSectionWidget(
                            nickname: data.nickname,
                            email: data.email,
                            mannerRate: data.mannerRate,
                            location: data.location,
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
                        ],
                      );
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

  void _navigateToPage<T>(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return T == RentalHistoryPage
                ? RentalHistoryPage(sizingInformation: sizingInformation)
                : RecentlyViewedPage(sizingInformation: sizingInformation);
          },
        ),
      ),
    );
  }
}