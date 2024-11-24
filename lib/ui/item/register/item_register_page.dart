import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import 'form_content.dart';
import '../../../service/item/item_register_service.dart'; // 서비스 import

// 물품 등록 페이지
class ItemRegisterPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const ItemRegisterPage({required this.sizingInformation, super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
    (sizingInformation.screenSize.width / 360).clamp(0.8, 1.2);

    return Scaffold(
      body: Center(
        child: Container(
          width: 360 * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AppTitle(title: '물품 등록'),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: FormContentWidget(
                    scaleWidth: scaleWidth,
                    onSubmit: (formData) => _handleFormSubmit(context, formData),
                  ),
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
        ),
      ),
    );
  }

  /// 폼 제출 처리 함수
  Future<void> _handleFormSubmit(BuildContext context, Map<String, dynamic> formData) async {
    final service = ItemRegisterService(baseUrl: 'https://your-api-url.com');

    // API 호출
    final isSuccess = await service.registerItem(
      name: formData['name'],
      description: formData['description'],
      period: formData['period'],
      fee: formData['fee'],
      deposit: formData['deposit'],
      location: formData['location'],
      categories: formData['categories'],
      images: formData['images'],
    );

    // 성공/실패 메시지 처리
    final message = isSuccess ? '물품 등록 성공' : '물품 등록 실패. 다시 시도해주세요.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}