import 'package:flutter/cupertino.dart';
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

  static const double baseWidth = 400;
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
            child: Container(
              width: 400 * scaleWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20 * scaleWidth),
                    child: _buildAppTitle(scaleWidth), // 제목 위젯
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10 * scaleHeight),
                            _buildIntroBox(scaleWidth, scaleHeight),
                            // 소개 박스
                            SizedBox(height: 20 * scaleHeight),
                            // 버튼과의 간격 유지
                            _buildKakaoLoginButton(scaleWidth, scaleHeight),
                            // 카카오 로그인 버튼
                          ],
                        ),
                      ),
                    ),
                  ),
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
    return (screenSize / baseSize).clamp(1.0, 1.5);
  }

  /// 앱 제목 위젯 빌더
  Widget _buildAppTitle(double scaleWidth) {
    return Text(
      '뭐든 대여',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF079702),
        fontSize: 25 * scaleWidth,
        // 크기 조정
        height: 1.2,
        fontFamily: 'BM Dohyeon',
        fontWeight: FontWeight.w900,
        shadows: [
          const Shadow(offset: Offset(-1.5, -1.5), color: Colors.white), // 왼쪽 위
          const Shadow(offset: Offset(1.5, -1.5), color: Colors.white), // 오른쪽 위
          const Shadow(offset: Offset(1.5, 1.5), color: Colors.white), // 오른쪽 아래
          const Shadow(offset: Offset(-1.5, 1.5), color: Colors.white), // 왼쪽 아래
          Shadow(
            offset: const Offset(2, 2), // 텍스트 아래 오른쪽 방향으로 그림자
            blurRadius: 4, // 흐림 정도
            color: Colors.grey.shade500, // 그림자 색상
          ),
        ],
      ),
    );
  }

  /// 페이지뷰 빌더
  Widget _buildPageView(double scaleWidth, double scaleHeight) {
    return Container(
      width: 290 * scaleWidth, // 가로 길이를 버튼보다 약간 길게 설정
      height: 520 * scaleHeight, // 높이를 기존보다 약간 더 증가
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10 * scaleWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10 * scaleWidth),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: List.generate(
            totalPageCount,
            (index) => _buildIntroImage(index),
          ),
        ),
      ),
    );
  }

  /// 소개 이미지 빌더 함수
  Widget _buildIntroImage(int index) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: Image.asset(
        'assets/images/intro${index + 1}.png',
        fit: BoxFit.contain,
      ),
    );
  }

  /// 페이지 인디케이터 빌더
  Widget _buildPageIndicator(double scaleWidth, double scaleHeight) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Row 크기를 자식 크기에 맞춤
      mainAxisAlignment: MainAxisAlignment.center, // Row 내부 정렬
      children: List.generate(
        totalPageCount,
        (index) => _buildIndicatorDot(index, scaleWidth, scaleHeight),
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

  /// 소개 컨텐츠 박스 빌더
  Widget _buildIntroBox(double scaleWidth, double scaleHeight) {
    return Container(
      width: 300 * scaleWidth,
      // 가로 길이를 카카오 버튼보다 약간 더 길게
      height: 600 * scaleHeight,
      // 높이 증가
      alignment: Alignment.topCenter,
      // 위쪽 정렬
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10 * scaleWidth),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 내부 콘텐츠 크기에 맞춤
        children: [
          SizedBox(height: 10 * scaleHeight), // 위쪽 여백 조정
          _buildPageView(scaleWidth, scaleHeight), // 소개 이미지
          SizedBox(height: 20 * scaleHeight), // 이미지와 인디케이터 간 여백
          _buildPageIndicator(scaleWidth, scaleHeight), // 페이지 인디케이터
        ],
      ),
    );
  }

  /// 카카오 로그인 버튼 빌더
  Widget _buildKakaoLoginButton(double scaleWidth, double scaleHeight) {
    return Column(
      children: [
        Text(
          '현재 카카오 로그인을 통해 로그인 진행 중입니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 8 * scaleWidth, // 작은 글씨 크기
            height: 1.2, // 줄 간격
            fontFamily: 'BM Dohyeon',
          ),
        ),
        SizedBox(height: 8 * scaleHeight), // 버튼과 문구 사이 간격
        Container(
          width: 350 * scaleWidth, // 버튼 너비를 소개 박스와 동일하게 설정
          alignment: Alignment.center, // 버튼 내부 정렬
          child: Container(
            width: 200 * scaleWidth,
            height: 45 * scaleHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF079702),
              borderRadius: BorderRadius.circular(5 * scaleWidth),
              border: Border.all(
                color: const Color(0xFF079702),
                width: 1.5,
              ),
            ),
            child: TextButton(
              onPressed: _handleKakaoLogin,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // 내부 여백 제거
              ),
              child: Stack(
                alignment: Alignment.center, // 콘텐츠 중앙 정렬
                children: [
                  Center(
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12 * scaleWidth,
                        height: 1.5,
                        fontFamily: 'BM Dohyeon',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 카카오 로그인 처리 함수
  Future<void> _handleKakaoLogin() async {
    final loginResponse = await _kakaoLoginService.loginWithKakao(context);

    if (loginResponse != null) {
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
      showErrorDialog(context, "로그인에 실패했습니다. 다시 시도해주세요.");
    }
  }
}
