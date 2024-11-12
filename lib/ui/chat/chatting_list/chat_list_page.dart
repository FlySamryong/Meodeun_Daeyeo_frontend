import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/action/chat_nav_action.dart';
import 'package:meodeundaeyeo/action/favorite_nav_action.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import 'chat_list.dart';
import '../../search_box.dart';

/// 채팅 목록 페이지 위젯 정의
class ChatListPage extends StatefulWidget {
  final SizingInformation sizingInformation;

  const ChatListPage({required this.sizingInformation, super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String _searchKeyword = ""; // 검색 키워드를 저장할 변수

  /// 검색 실행 시 호출되는 함수 (검색 키워드를 사용)
  void _onSearch() {
    print("Searching for: $_searchKeyword");
  }

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        _calculateScaleWidth(widget.sizingInformation.screenSize.width);

    return Scaffold(
      body: Center(
        child: Container(
          width: 360 * scaleWidth, // 화면 크기에 맞춰 너비 조정
          child: Column(
            children: [
              const SizedBox(height: 20), // 상단 여백
              const AppTitle(title: '채팅 목록'), // 페이지 제목
              const SizedBox(height: 10), // 제목과 검색창 사이 여백
              _buildSearchBox(), // 검색창 위젯
              const SizedBox(height: 15), // 검색창과 채팅 리스트 사이 여백
              _buildChatList(), // 채팅 목록 위젯
              _buildBottomNavBar(), // 하단 네비게이션 바 위젯
            ],
          ),
        ),
      ),
    );
  }

  /// 화면 크기에 따른 너비 비율을 계산하는 함수
  double _calculateScaleWidth(double screenWidth) {
    return (screenWidth / 360).clamp(0.8, 1.2); // 최소 0.8, 최대 1.2로 제한
  }

  /// 검색 박스를 생성하는 위젯 빌더
  Widget _buildSearchBox() {
    return SearchBox(
      hintText: '채팅 검색', // 검색창 힌트 텍스트
      onSearch: (keyword) {
        setState(() {
          _searchKeyword = keyword; // 검색어 갱신
        });
        _onSearch(); // 갱신된 검색어로 검색 실행
      },
    );
  }

  /// 채팅 목록을 생성하는 위젯 빌더
  Widget _buildChatList() {
    return Expanded(
      child: ChatList(
        scrollController: ScrollController(), // 채팅 목록 스크롤 제어
        sizingInformation: widget.sizingInformation, // 반응형 사이징 정보 전달
      ),
    );
  }

  /// 하단 네비게이션 바를 생성하는 위젯 빌더
  Widget _buildBottomNavBar() {
    return BottomNavBar(
      homeAction: HomeNavAction(widget.sizingInformation),
      // 홈 화면 이동 액션
      favoritesAction: FavoriteNavAction(widget.sizingInformation),
      // 즐겨찾기 화면 이동 액션
      chatAction: ChatNavAction(widget.sizingInformation),
      // 채팅 화면 이동 액션
      profileAction: MyPageNavAction(widget.sizingInformation), // 마이페이지 이동 액션
    );
  }
}
