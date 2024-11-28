import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/action/chat_nav_action.dart';
import 'package:meodeundaeyeo/action/favorite_nav_action.dart';
import 'package:meodeundaeyeo/action/home_nav_action.dart';
import 'package:meodeundaeyeo/action/mypage_nav_action.dart';
import 'package:meodeundaeyeo/ui/item/register/item_register_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../app_title.dart';
import '../bottom_nav_bar.dart';
import 'item_list.dart';
import '../search_box.dart';
import 'filter.dart';

class MainPage extends StatefulWidget {
  final SizingInformation sizingInformation;

  const MainPage({required this.sizingInformation, super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _selectedCategory = "전자제품";
  String _selectedCity = "서울시";
  String _selectedDistrict = "강남구";
  String _selectedDong = "역삼동";
  String _searchKeyword = ""; // 검색어 저장 변수

  @override
  Widget build(BuildContext context) {
    final double scaleWidth = _calculateScaleWidth();

    return Scaffold(
      body: Center(
        child: Container(
          width: 400 * scaleWidth, // 화면 크기에 따른 가변 너비 설정
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  const AppTitle(title: '메인 페이지'),
                  const SizedBox(height: 10),
                  _buildFilterWidget(), // 필터 위젯
                  const SizedBox(height: 10),
                  _buildSearchBox(), // 검색창
                  const SizedBox(height: 15),
                  _buildItemList(), // 아이템 리스트
                  _buildBottomNavBar(), // 하단 네비게이션 바
                ],
              ),
              _buildFloatingActionButton(), // 플로팅 액션 버튼
            ],
          ),
        ),
      ),
    );
  }

  /// 화면 크기에 따른 스케일 너비 계산
  double _calculateScaleWidth() {
    return (widget.sizingInformation.screenSize.width / 400).clamp(1.0, 1.5);
  }

  /// 필터 위젯 빌더 함수
  Widget _buildFilterWidget() {
    return FilterWidget(
      selectedCategory: _selectedCategory,
      selectedCity: _selectedCity,
      selectedDistrict: _selectedDistrict,
      selectedDong: _selectedDong,
      onCategoryChanged: (value) => setState(() => _selectedCategory = value),
      onCityChanged: (value) => setState(() => _selectedCity = value),
      onDistrictChanged: (value) => setState(() => _selectedDistrict = value),
      onDongChanged: (value) => setState(() => _selectedDong = value),
    );
  }

  /// 검색창 위젯 빌더 함수
  Widget _buildSearchBox() {
    return SearchBox(
      hintText: '검색',
      onSearch: (keyword) {
        setState(() {
          _searchKeyword = keyword;
        });
      },
    );
  }

  /// 아이템 리스트 위젯 빌더 함수
  Widget _buildItemList() {
    return Expanded(
      child: ItemListWidget(
        sizingInformation: widget.sizingInformation,
        category: _selectedCategory,
        city: _selectedCity,
        district: _selectedDistrict,
        neighborhood: _selectedDong,
        keyword: _searchKeyword,
      ),
    );
  }

  /// 하단 네비게이션 바 위젯 빌더 함수
  Widget _buildBottomNavBar() {
    return BottomNavBar(
      homeAction: HomeNavAction(widget.sizingInformation),
      favoritesAction: FavoriteNavAction(widget.sizingInformation),
      chatAction: ChatNavAction(widget.sizingInformation),
      profileAction: MyPageNavAction(widget.sizingInformation),
    );
  }

  /// 플로팅 액션 버튼 빌더 함수
  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemRegisterPage(
                sizingInformation: widget.sizingInformation,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF079702),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
