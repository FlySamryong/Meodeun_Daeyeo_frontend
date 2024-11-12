import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../../service/item/item_detail_service.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import 'action_button.dart';
import 'item_detail_box.dart';
import 'owner_info_box.dart';

class ItemDetailScreen extends StatefulWidget {
  final SizingInformation sizingInformation;
  final int itemId;

  const ItemDetailScreen(
      {super.key, required this.sizingInformation, required this.itemId});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final ItemService _itemService = ItemService();
  late Future<Map<String, dynamic>> itemDetails;

  @override
  void initState() {
    super.initState();
    itemDetails = _fetchItemDetails();
  }

  /// 아이템 상세 정보 API 호출 함수
  Future<Map<String, dynamic>> _fetchItemDetails() async {
    try {
      return await _itemService.fetchItemDetails(
        itemId: widget.itemId,
        context: context,
      );
    } catch (e) {
      throw Exception('Failed to load item details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = _calculateContainerWidth();

    return Scaffold(
      body: Center(
        child: Container(
          width: containerWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppTitle(title: '아이템 상세 정보'), // 화면 제목
              const SizedBox(height: 10),
              _buildContent(), // 메인 컨텐츠
              _buildBottomNavBar(), // 하단 네비게이션 바
            ],
          ),
        ),
      ),
    );
  }

  /// 화면 크기에 맞춘 컨테이너 너비 계산 함수
  double _calculateContainerWidth() {
    return 360 *
        (widget.sizingInformation.screenSize.width / 360).clamp(0.8, 1.2);
  }

  /// 메인 컨텐츠 빌더 함수 (FutureBuilder 사용)
  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: itemDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else if (snapshot.hasData) {
              return _buildItemDetailContent(snapshot.data!);
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  /// 아이템 상세 정보가 있는 경우 화면 구성
  Widget _buildItemDetailContent(Map<String, dynamic> data) {
    return Column(
      children: [
        ItemDetailBoxWidget(data: data),
        const SizedBox(height: 20),
        OwnerInfoBoxWidget(data: data),
        const SizedBox(height: 20),
        ActionButtonsWidget(
            data: data, sizingInformation: widget.sizingInformation),
        const SizedBox(height: 20),
      ],
    );
  }

  /// 오류 발생 시 보여줄 위젯
  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  /// 하단 네비게이션 바 빌더 함수
  Widget _buildBottomNavBar() {
    return BottomNavBar(
      homeAction: HomeNavAction(widget.sizingInformation),
      favoritesAction: FavoriteNavAction(widget.sizingInformation),
      chatAction: ChatNavAction(widget.sizingInformation),
      profileAction: MyPageNavAction(widget.sizingInformation),
    );
  }
}
