import 'package:flutter/material.dart';
import 'item_detail_text.dart';

/// 물품 등록자 정보 박스 위젯
class OwnerInfoBoxWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const OwnerInfoBoxWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 10),
          _buildOwnerInfoRow(), // 등록자 정보가 들어있는 행
        ],
      ),
    );
  }

  /// 박스의 decoration을 설정하는 함수
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: const Offset(0, 2),
          blurRadius: 5,
        ),
      ],
    );
  }

  /// '물품 등록자 정보' 텍스트 위젯
  Widget _buildTitle() {
    return const Text(
      '물품 등록자 정보',
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'BM Dohyeon',
        color: Colors.black,
      ),
    );
  }

  /// 등록자 정보가 포함된 행을 구성하는 함수
  Widget _buildOwnerInfoRow() {
    return Row(
      children: [
        _buildOwnerImage(), // 등록자 이미지
        const SizedBox(width: 10),
        Expanded(child: _buildOwnerDetails()), // 등록자 세부 정보
      ],
    );
  }

  /// 등록자 세부 정보 텍스트를 구성하는 함수
  Widget _buildOwnerDetails() {
    final owner = data['owner']; // owner 객체를 변수에 저장
    final location = owner?['location']; // location 객체를 변수에 저장

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailTextWidget(text: '닉네임: ${owner?['nickName'] ?? '미입력'}'),
        DetailTextWidget(
            text:
                '거주지: ${location?['city'] ?? '미입력'} ${location?['district'] ?? '미입력'} ${location?['neighborhood'] ?? '미입력'}'),
        DetailTextWidget(
          text: '등록자 별점 후기: ${owner?['mannerRate'] ?? '미입력'} / 5',
        ),
      ],
    );
  }

  /// 등록자 이미지를 설정하는 함수
  Widget _buildOwnerImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10), // 사각형 모서리를 둥글게 설정
        image: _getOwnerImage(),
      ),
    );
  }

  /// 프로필 이미지 URL 또는 기본 이미지 제공 함수
  DecorationImage _getOwnerImage() {
    final imageUrl = data['owner']?['profileImage'];
    return DecorationImage(
      image: imageUrl != null
          ? NetworkImage(imageUrl)
          : const AssetImage('assets/images/owner.png') as ImageProvider,
      fit: BoxFit.cover,
    );
  }
}
