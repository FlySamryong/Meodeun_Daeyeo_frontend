import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../service/auth/service/auth_service.dart';
import '../../service/auth/service/kakao_login_service.dart';
import '../../utils/show_error_dialog.dart';
import '../home/main_page.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final KakaoLoginService _kakaoLoginService = KakaoLoginService();
  final AuthService _authService = AuthService();

  static const double baseWidth = 360;
  static const double baseHeight = 800;
  static const int totalPageCount = 3;
  static const double indicatorSize = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ResponsiveBuilder(
        builder: (context, sizingInfo) {
          final double scaleWidth =
              _calculateScale(sizingInfo.screenSize.width, baseWidth);
          final double scaleHeight =
              _calculateScale(sizingInfo.screenSize.height, baseHeight);

          return Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20 * scaleHeight),
                  _buildAppTitle(scaleWidth),
                  SizedBox(height: 45 * scaleHeight),
                  _buildIntroBox(scaleWidth, scaleHeight),
                  SizedBox(height: 20 * scaleHeight),
                  _buildKakaoLoginButton(scaleWidth, scaleHeight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 스케일 계산 함수
  double _calculateScale(double screenSize, double baseSize) {
    return (screenSize / baseSize).clamp(0.8, 1.2);
  }

  /// 앱 제목 위젯 빌더
  Widget _buildAppTitle(double scaleWidth) {
    return Text(
      '뭐든 대여',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 32 * scaleWidth,
        fontFamily: 'BM Dohyeon',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// 소개 컨텐츠 박스 빌더
  Widget _buildIntroBox(double scaleWidth, double scaleHeight) {
    return Container(
      width: 337 * scaleWidth,
      height: 550 * scaleHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * scaleWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildPageView(scaleWidth, scaleHeight),
          _buildPageIndicator(scaleWidth, scaleHeight),
        ],
      ),
    );
  }

  /// 페이지뷰 빌더
  Widget _buildPageView(double scaleWidth, double scaleHeight) {
    return Positioned(
      left: 4 * scaleWidth,
      top: 9 * scaleHeight,
      child: Container(
        width: 328 * scaleWidth,
        height: 480 * scaleHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10 * scaleWidth),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children:
              List.generate(totalPageCount, (index) => _buildIntroImage(index)),
        ),
      ),
    );
  }

  /// 소개 이미지 빌더 함수
  Widget _buildIntroImage(int index) {
    return Image.asset(
      'assets/images/intro${index + 1}.png',
      fit: BoxFit.cover,
    );
  }

  /// 페이지 인디케이터 빌더
  Widget _buildPageIndicator(double scaleWidth, double scaleHeight) {
    return Positioned(
      bottom: 20 * scaleHeight,
      left: (337 * scaleWidth) / 2 - 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPageCount,
            (index) => _buildIndicatorDot(index, scaleWidth, scaleHeight)),
      ),
    );
  }

  /// 인디케이터 점 생성 함수
  Widget _buildIndicatorDot(int index, double scaleWidth, double scaleHeight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: indicatorSize * scaleWidth,
      height: indicatorSize * scaleHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? const Color(0xFF079702) : Colors.grey,
      ),
    );
  }

  /// 카카오 로그인 버튼 빌더
  Widget _buildKakaoLoginButton(double scaleWidth, double scaleHeight) {
    return Container(
      width: 251 * scaleWidth,
      height: 45 * scaleHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF079702).withOpacity(0.95),
        borderRadius: BorderRadius.circular(5 * scaleWidth),
      ),
      child: TextButton(
        onPressed: _handleKakaoLogin,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 8 * scaleHeight,
            horizontal: 16 * scaleWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/kakaolink_btn_small.png',
              width: 28 * scaleWidth,
              height: 28 * scaleHeight,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8 * scaleWidth),
            Text(
              'Kakao Login',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16 * scaleWidth,
                fontFamily: 'BM Dohyeon',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카카오 로그인 처리 함수
  Future<void> _handleKakaoLogin() async {
    final loginResponse = await _kakaoLoginService.loginWithKakao(context);

    if (loginResponse != null) {
      // 로그인 성공 시 MainPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveBuilder(
            builder: (context, sizingInformation) =>
                MainPage(sizingInformation: sizingInformation),
          ),
        ),
      );
    } else {
      // 로그인 실패 시 오류 메시지 표시
      showErrorDialog(context, "로그인에 실패했습니다. 다시 시도해주세요.");
    }
  }
}
