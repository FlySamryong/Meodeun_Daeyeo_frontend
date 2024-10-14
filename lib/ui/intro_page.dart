import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../service/auth/service/kakao_login_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '25d976307eb5178b1ccaf831fd63e1fa',
    javaScriptAppKey: '42559361f1b22248d18364e6999d0a13',
  );

  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const IntroScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final KakaoLoginService _kakaoLoginService = KakaoLoginService();

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
              (sizingInfo.screenSize.width / baseWidth).clamp(0.8, 1.2);
          final double scaleHeight =
              (sizingInfo.screenSize.height / baseHeight).clamp(0.8, 1.2);

          return Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 1 * scaleHeight),
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

  // 앱 제목 위젯
  Widget _buildAppTitle(double scaleWidth) {
    return Text(
      '뭐든 대여',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 32 * scaleWidth,
        fontFamily: 'BM Dohyeon',
        fontWeight: FontWeight.w400,
        height: 1.0,
      ),
    );
  }

  // 소개 컨텐츠 박스
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

  // 소개 화면용 PageView
  Widget _buildPageView(double scaleWidth, double scaleHeight) {
    return Positioned(
      left: 4 * scaleWidth,
      top: 9 * scaleHeight,
      child: Container(
        width: 328 * scaleWidth,
        height: 480 * scaleHeight,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10 * scaleWidth),
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: List.generate(totalPageCount, (index) {
            return Image.asset('assets/images/intro${index + 1}.png',
                fit: BoxFit.cover);
          }),
        ),
      ),
    );
  }

  // 소개 화면용 페이지 인디케이터
  Widget _buildPageIndicator(double scaleWidth, double scaleHeight) {
    return Positioned(
      bottom: 20 * scaleHeight,
      left: (337 * scaleWidth) / 2 - 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPageCount, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: indicatorSize * scaleWidth,
            height: indicatorSize * scaleHeight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Color(0xFF079702) : Colors.grey,
            ),
          );
        }),
      ),
    );
  }

  // 카카오 로그인 버튼
  Widget _buildKakaoLoginButton(double scaleWidth, double scaleHeight) {
    return Container(
      width: 251 * scaleWidth,
      height: 45 * scaleHeight,
      decoration: ShapeDecoration(
        color: const Color(0xFF079702).withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5 * scaleWidth),
        ),
      ),
      child: TextButton(
        onPressed: () async {
          await _kakaoLoginService.loginWithKakao(context);
        },
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
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
