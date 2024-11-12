import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../home/main_page.dart';
import 'appbar_icon.dart';

/// 채팅방 상단바
class ChatAppBar extends StatelessWidget {
  final String title;

  const ChatAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHomeButton(context),
          _buildTitle(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 홈 버튼 생성
  Widget _buildHomeButton(BuildContext context) {
    return IconButtonWidget(
      icon: Icons.home,
      color: const Color(0xFF079702).withOpacity(0.95),
      onPressed: () => _navigateToHomePage(context),
    );
  }

  /// 홈 화면으로 네비게이션
  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return MainPage(sizingInformation: sizingInformation);
          },
        ),
      ),
    );
  }

  /// 채팅방 제목 생성
  Widget _buildTitle() {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'BM Dohyeon',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  /// 오른쪽에 위치한 액션 버튼들 생성
  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildActionButton(Icons.thermostat, Colors.yellow, () {
          // 매너 온도 기능
        }),
        _buildActionButton(Icons.report, Colors.red, () {
          // 신고 기능
        }),
      ],
    );
  }

  /// 액션 버튼을 만드는 함수
  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButtonWidget(
      icon: icon,
      color: color.withOpacity(0.95),
      onPressed: onPressed,
    );
  }
}
