import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ui/chat/chat_list_page.dart';
import 'bottom_nav_action.dart';

class ChatNavAction implements BottomNavAction {
  final SizingInformation sizingInformation;

  ChatNavAction(this.sizingInformation);

  @override
  void onTap(BuildContext context) {
    // 채팅 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatListPage(sizingInformation: sizingInformation),
      ),
    );
  }
}
