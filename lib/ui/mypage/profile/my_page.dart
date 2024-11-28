import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../service/mypage/mypage_service.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import '../section.dart';
import '../accout_register/account_registeration_dialog.dart';
import 'profile_section.dart';
import '../location_register/location_registeration_dialog.dart';
import '../rent_history/rental_history_page.dart';
import '../recent_item/recent_view_item_page.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';

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

  /// 데이터를 새로고침하는 메서드
  Future<void> _updateMyPageData() async {
    setState(() {
      _myPageDataFuture = MyPageService().fetchMyPageData(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double baseWidth = 400;
    final double scaleWidth =
        (widget.sizingInformation.screenSize.width / baseWidth).clamp(1.0, 1.5);

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
                      return _buildMyPageContent(data);
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

  /// 마이페이지 콘텐츠 빌드
  Widget _buildMyPageContent(MyPageData data) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 계좌 등록하기 버튼
              _buildOutlinedButton(
                label: "계좌 등록하기",
                onPressed: () => _showAccountRegistrationDialog(context),
              ),
              const SizedBox(width: 8), // 버튼 간격
              // 거주지 등록하기 버튼
              _buildOutlinedButton(
                label: "거주지 등록하기",
                onPressed: () async {
                  // 다이얼로그 실행 후 데이터 업데이트
                  await _showLocationRegistrationDialog(context);
                  await _updateMyPageData();
                },
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
          () => _launchUrl(
            'https://thirsty-carob-1df.notion.site/14b4f6c4f9c88065b4a3d86564787ee1',
            context,
          ),
        ),
        const SizedBox(height: 30),
        _buildSection(
          context,
          '이용 약관',
          Icons.arrow_forward,
          () => _launchUrl(
            'https://thirsty-carob-1df.notion.site',
            context,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// 아웃라인 버튼 생성
  Widget _buildOutlinedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 계좌 등록 다이얼로그 표시
  void _showAccountRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AccountRegistrationDialog(parentContext: context);
      },
    );
  }

  /// 거주지 등록 다이얼로그 표시
  Future<void> _showLocationRegistrationDialog(BuildContext context) async {
    final selectedLocation = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return LocationRegistrationDialog(parentContext: context);
      },
    );

    if (selectedLocation != null) {
      // TODO: 서버로 데이터 전송 로직 추가
    }
  }

  /// 섹션 빌드
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

  /// URL 열기 함수
  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // URL을 열 수 없는 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL을 열 수 없습니다.')),
      );
    }
  }
}
