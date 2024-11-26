// 물품 등록 페이지
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../action/chat_nav_action.dart';
import '../../../action/favorite_nav_action.dart';
import '../../../action/home_nav_action.dart';
import '../../../action/mypage_nav_action.dart';
import '../../../service/item/item_register_service.dart';
import '../../app_title.dart';
import '../../bottom_nav_bar.dart';
import 'form_content.dart';

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

  Future<void> _handleFormSubmit(
      BuildContext context, Map<String, dynamic> formData) async {
    final service = ItemRegisterService();

    try {
      if (formData['name'].isEmpty ||
          formData['description'].isEmpty ||
          formData['locationDTO'].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필수 입력값이 비어 있습니다.')),
        );
        return;
      }

      final itemId = await service.registerItem(
        context: context,
        imageList: List<String>.from(formData['imageList']),
        itemDTO: {
          'name': formData['name'],
          'description': formData['description'],
          'period': formData['period'],
          'fee': formData['fee'],
          'deposit': formData['deposit'],
          'categoryList': List<Map<String, dynamic>>.from(formData['categoryList']),
        },
        locationDTO: Map<String, dynamic>.from(formData['locationDTO']),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('물품 등록 성공! ID: $itemId')),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('물품 등록 실패: $e')),
      );
    }
  }
}