import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ui/home/main_page.dart';
import 'bottom_nav_action.dart';

class HomeNavAction implements BottomNavAction {
  final SizingInformation sizingInformation;

  HomeNavAction(this.sizingInformation);

  @override
  void onTap(BuildContext context) {
    // 메인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(sizingInformation: sizingInformation),
      ),
    );
  }
}
