import 'package:flutter/material.dart';

/// 프로필 섹션 위젯
class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: _buildContainerDecoration(),
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

  /// 컨테이너의 장식 스타일 반환 함수
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: const Color(0xFF079702).withOpacity(0.95),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  /// 프로필 이미지 반환 함수
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

  /// 프로필 세부 사항 반환 함수
  Widget _buildProfileDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          _buildProfileDetailText('닉네임: 홍길동', fontWeight: FontWeight.bold),
          SizedBox(height: 5),
          _buildProfileDetailText('이메일: example@example.com'),
          SizedBox(height: 5),
          _buildProfileDetailText('등록자 별점 후기: 3.5 / 5'),
          SizedBox(height: 5),
          _buildProfileDetailText('계좌번호: 123-456-789'),
          SizedBox(height: 5),
          _buildProfileDetailText('거주지: 서울시 강남구'),
        ],
      ),
    );
  }

  /// 프로필 세부 사항 텍스트 스타일을 반환하는 함수
  static Widget _buildProfileDetailText(String text, {FontWeight fontWeight = FontWeight.w100}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: fontWeight,
        fontFamily: 'BM Dohyeon',
      ),
    );
  }
}
