import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../home/main_page.dart';
import 'appbar_icon.dart';

// 채팅방 상단바
class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButtonWidget(
            icon: Icons.home,
            color: const Color(0xFF079702).withOpacity(0.95),
            onPressed: () {
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
            },
          ),
          Expanded(
            child: Center(
              child: const Text(
                '상대방 닉네임',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BM Dohyeon',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButtonWidget(
                icon: Icons.thermostat,
                color: Colors.yellow.withOpacity(0.95),
                onPressed: () {
                  // 매너 온도 기능
                },
              ),
              IconButtonWidget(
                icon: Icons.report,
                color: Colors.red.withOpacity(0.95),
                onPressed: () {
                  // 신고 기능
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
