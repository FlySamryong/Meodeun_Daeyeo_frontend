import 'package:flutter/material.dart';

import '../../../service/mypage/mypage_service.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String nickname;
  final String email;
  final double mannerRate;
  final Location location;

  const ProfileSectionWidget({
    super.key,
    required this.nickname,
    required this.email,
    required this.mannerRate,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
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

  Widget _buildProfileDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileDetailText('닉네임: $nickname', fontWeight: FontWeight.bold),
          _buildProfileDetailText('이메일: $email'),
          _buildProfileDetailText('등록자 별점: $mannerRate / 5'),
          _buildProfileDetailText(
              '거주지: ${location.city}, ${location.district}, ${location.neighborhood}'),
        ],
      ),
    );
  }

  static Widget _buildProfileDetailText(String text,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, fontWeight: fontWeight),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: const Color(0xFF079702).withOpacity(0.95),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
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
}