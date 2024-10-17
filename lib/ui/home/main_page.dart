import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/action/chat_nav_action.dart';
import 'package:meodeundaeyeo/action/favorite_nav_action.dart';
import 'package:meodeundaeyeo/action/home_nav_action.dart';
import 'package:meodeundaeyeo/action/mypage_nav_action.dart';
import 'package:meodeundaeyeo/ui/item/item_register_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../widget/app_title.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/item/item_list.dart';
import '../widget/search_box.dart';
import '../widget/filter_button.dart';

void main() {
  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Scaffold(
            body: Center(
              child: MainPage(sizingInformation: sizingInformation),
            ),
          );
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const MainPage({required this.sizingInformation, super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (sizingInformation.screenSize.width / 360).clamp(0.8, 1.2);

    return Scaffold(
      body: Center(
        child: Container(
          width: 360 * scaleWidth,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  const AppTitle(title: '메인 페이지'),
                  const SizedBox(height: 10),
                  _buildFilterButtons(),
                  const SizedBox(height: 10),
                  const SearchBox(hintText: '검색'),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ItemListWidget(
                      sizingInformation: sizingInformation,
                    ),
                  ),
                  BottomNavBar(
                    homeAction: HomeNavAction(sizingInformation),
                    favoritesAction: FavoriteNavAction(sizingInformation),
                    chatAction: ChatNavAction(sizingInformation),
                    profileAction: MyPageNavAction(sizingInformation),
                  ),
                ],
              ),
              Positioned(
                bottom: 80,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemRegisterPage(
                            sizingInformation: sizingInformation),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFF079702),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
        children: [
          FilterButtonWidget(
            label: '카테고리',
            width: 100,
            onPressed: () {
              // 카테고리 필터 로직 추가 예정
            },
          ),
          const SizedBox(width: 8),
          FilterButtonWidget(
            label: '거주지',
            width: 100,
            onPressed: () {
              // 거주지 필터 로직 추가 예정
            },
          ),
        ],
      ),
    );
  }
}
