import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '25d976307eb5178b1ccaf831fd63e1fa',
    javaScriptAppKey: '42559361f1b22248d18364e6999d0a13',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    );
  }
}