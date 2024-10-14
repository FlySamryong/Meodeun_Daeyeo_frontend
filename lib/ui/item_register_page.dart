import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
        builder: (context, sizingInfo) {
          return Scaffold(
            body: Center(
              child: ItemRegisterPage(sizingInfo: sizingInfo),
            ),
          );
        },
      ),
    );
  }
}

class ItemRegisterPage extends StatelessWidget {
  final SizingInformation sizingInfo;
  const ItemRegisterPage({required this.sizingInfo});

  static const double baseWidth = 360;
  static const double baseHeight = 800;

  @override
  Widget build(BuildContext context) {
    final double scaleWidth = (sizingInfo.screenSize.width / baseWidth).clamp(0.8, 1.2);
    final double scaleHeight = (sizingInfo.screenSize.height / baseHeight).clamp(0.8, 1.2);

    return Center(
      child: Container(
        width: baseWidth * scaleWidth,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAppTitle(scaleWidth, scaleHeight),
            const SizedBox(height: 10),
            _buildFormContent(scaleWidth, scaleHeight),
            const SizedBox(height: 20),
            _buildSubmitButton(scaleWidth),
            const SizedBox(height: 20),
            _buildBottomNavBar(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 앱 제목
  Widget _buildAppTitle(double scaleWidth, double scaleHeight) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          '뭐든 대여',
          style: TextStyle(
            fontSize: 14 * scaleWidth,
            fontWeight: FontWeight.bold,
            fontFamily: 'BM Dohyeon',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // 폼 내용
  Widget _buildFormContent(double scaleWidth, double scaleHeight) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15 * scaleWidth),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10 * scaleWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPhotoUploadBox(scaleWidth, scaleHeight),
              const SizedBox(height: 15),
              _buildInputField('물품명', scaleWidth),
              const SizedBox(height: 10),
              _buildInputField('거래 장소', scaleWidth),
              const SizedBox(height: 10),
              _buildInputField('1일 대여료', scaleWidth),
              const SizedBox(height: 10),
              _buildInputField('보증금', scaleWidth),
              const SizedBox(height: 10),
              _buildInputField('대여 가능 기간', scaleWidth),
              const SizedBox(height: 10),
              _buildInputField('물품 카테고리', scaleWidth),
              const SizedBox(height: 20),
              _buildDescriptionField(scaleWidth, scaleHeight),
            ],
          ),
        ),
      ),
    );
  }

  // 사진 업로드 박스
  Widget _buildPhotoUploadBox(double scaleWidth, double scaleHeight) {
    return Container(
      width: double.infinity,
      height: 150 * scaleHeight,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10 * scaleWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.add_a_photo,
          size: 50 * scaleWidth,
          color: Colors.grey,
        ),
      ),
    );
  }

  // 입력 필드 생성기
  Widget _buildInputField(String labelText, double scaleWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5 * scaleWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontFamily: 'BM Dohyeon',
            color: Colors.black,
            fontSize: 14 * scaleWidth,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // 설명 필드 생성기
  Widget _buildDescriptionField(double scaleWidth, double scaleHeight) {
    return Container(
      padding: EdgeInsets.all(10 * scaleWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5 * scaleWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        maxLines: 5,
        decoration: InputDecoration(
          labelText: '물품에 대한 자세한 설명',
          labelStyle: TextStyle(
            fontFamily: 'BM Dohyeon',
            color: Colors.black,
            fontSize: 14 * scaleWidth,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // 제출 버튼 생성기
  Widget _buildSubmitButton(double scaleWidth) {
    return ElevatedButton(
      onPressed: () {
        // 제출 로직 처리
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15 * scaleWidth, horizontal: 50 * scaleWidth),
        backgroundColor: const Color(0xFF079702).withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * scaleWidth),
        ),
      ),
      child: Text(
        '등록하기',
        style: TextStyle(
          fontFamily: 'BM Dohyeon',
          fontSize: 16 * scaleWidth,
          color: Colors.white,
        ),
      ),
    );
  }

  // 하단 네비게이션 바
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF079702).withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarButton('홈', Icons.home),
          _buildNavBarButton('좋아요', Icons.favorite),
          _buildNavBarButton('채팅', Icons.chat),
          _buildNavBarButton('마이페이지', Icons.person),
        ],
      ),
    );
  }

  // 하단 바의 네비게이션 버튼
  Widget _buildNavBarButton(String title, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
