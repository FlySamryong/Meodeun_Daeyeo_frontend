import 'package:flutter/material.dart';
import 'item_detail_text.dart';

// 물품 등록자 정보 박스 위젯
class OwnerInfoBoxWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const OwnerInfoBoxWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '물품 등록자 정보',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'BM Dohyeon',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildOwnerImage(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailTextWidget(text: '닉네임: ${data['lender_nickname']}'),
                    DetailTextWidget(text: '거주지: ${data['lender_location']}'),
                    DetailTextWidget(
                        text: '등록자 별점 후기: ${data['lender_manner_temp']} / 5'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 추후 이미지를 서버에서 받아오는 방식으로 수정 필요
  Widget _buildOwnerImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10), // 사각형 모서리를 약간 둥글게 설정
        image: const DecorationImage(
          image: AssetImage('assets/images/intro1.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
