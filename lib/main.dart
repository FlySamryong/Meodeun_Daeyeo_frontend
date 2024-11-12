import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:meodeundaeyeo/ui/intro/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kakao SDK 초기화
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
      theme: ThemeData.light().copyWith(
        // 앱 전체의 기본 배경색을 흰색으로 설정
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF079702), // 기본 primary color 설정
        textTheme: ThemeData.light().textTheme.apply(
            ),
      ),
      home: const IntroScreen(),
      routes: {
        '/login': (context) => const IntroScreen(),
      },
    );
  }
}
