import 'package:flutter/material.dart';

// 프로필 섹션 위젯
class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF079702).withOpacity(0.95),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _buildProfileImage(),
            const SizedBox(width: 15),
            _buildProfileDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text('프로필', style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  // 추후 이미지를 서버에서 받아오는 방식으로 수정 필요
  Widget _buildProfileDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '닉네임: 홍길동',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'BM Dohyeon',
            ),
          ),
          SizedBox(height: 5),
          Text('이메일: example@example.com'),
          SizedBox(height: 5),
          Text('등록자 별점 후기: 3.5 / 5'),
          SizedBox(height: 5),
          Text('계좌번호: 123-456-789'),
          SizedBox(height: 5),
          Text('거주지: 서울시 강남구'),
        ],
      ),
    );
  }
}
