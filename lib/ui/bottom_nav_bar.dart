import 'package:flutter/material.dart';
import '../action/bottom_nav_action.dart';

// 하단 네비게이션 바 위젯
class BottomNavBar extends StatelessWidget {
  final BottomNavAction? homeAction;
  final BottomNavAction? favoritesAction;
  final BottomNavAction? chatAction;
  final BottomNavAction? profileAction;

  const BottomNavBar({
    this.homeAction,
    this.favoritesAction,
    this.chatAction,
    this.profileAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF079702).withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton('홈', Icons.home, homeAction),
          _buildNavButton('좋아요', Icons.favorite, favoritesAction),
          _buildNavButton('채팅', Icons.chat, chatAction),
          _buildNavButton('마이페이지', Icons.person, profileAction),
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, IconData icon, BottomNavAction? action) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: action != null ? () => action.onTap(context) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
