import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../../service/mypage/mypage_service.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import '../section.dart';
import 'profile_section.dart';
import '../recent_item/recent_view_item_page.dart';
import '../rent_history/rental_history_page.dart';
import '../accout_register/account_registeration_dialog.dart';

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
                            nickName: data.nickName,
                            email: data.email,
                            mannerRate: data.mannerRate,
                            location: data.location,
                            profileImage: data.profileImage,
                            accountNum: data.accountList.isNotEmpty
                                ? data.accountList.first.accountNum
                                : '없음',
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
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

  /// 계좌 등록 다이얼로그 표시 함수
  void _showAccountRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
