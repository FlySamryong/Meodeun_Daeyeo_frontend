import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/utils/show_success_dialog.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../service/chat/service/chat_page_service.dart';
import '../../../home/main_page.dart';
import 'appbar_icon.dart';
import 'manner_rate_dialog.dart';

/// 채팅방 상단바
class ChatAppBar extends StatelessWidget {
  final String title;
  final int roomId;

  const ChatAppBar({required this.title, required this.roomId, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHomeButton(context),
          _buildTitle(),
          _buildActionButtons(context),
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
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(Icons.thermostat, Colors.yellow, () {
          _showMannerRateDialog(context);
        }),
        _buildActionButton(Icons.report, Colors.red, () {
          // 신고 기능
        }),
      ],
    );
  }

  /// 액션 버튼을 만드는 함수
  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return IconButtonWidget(
      icon: icon,
      color: color.withOpacity(0.95),
      onPressed: onPressed,
    );
  }

  /// 매너 온도 설정 다이얼로그 표시
  void _showMannerRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MannerRateDialog(
          onRateSelected: (int mannerRate) {
            _handleUpdateMannerRate(context, mannerRate);
          },
        );
      },
    );
  }

  /// 매너 온도 업데이트 처리
  void _handleUpdateMannerRate(BuildContext context, int mannerRate) async {
    final chatService = ChatService();

    final success = await chatService.updateMannerRate(
      roomId: roomId, // 동적으로 roomId 전달
      mannerRate: mannerRate,
      context: context,
    );

    if (success) {
      showSuccessDialog(context, "매너 점수를 반영했습니다.");
    }
  }
}
