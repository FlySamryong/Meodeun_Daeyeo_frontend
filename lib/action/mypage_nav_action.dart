import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../ui/mypage/my_page.dart';
import 'bottom_nav_action.dart';

class MyPageNavAction implements BottomNavAction {
  final SizingInformation sizingInformation;

  MyPageNavAction(this.sizingInformation);

  @override
  void onTap(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyPage(sizingInformation: sizingInformation),
      ),
    );
  }
}
