import 'package:flutter/material.dart';

/// 이미지 슬라이드 위젯
class ImageCarouselWidget extends StatelessWidget {
  final List<dynamic> imageList;

  const ImageCarouselWidget({required this.imageList, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: _containerDecoration(),
      child: imageList.isNotEmpty ? _buildImageCarousel() : _buildNoImages(),
    );
  }

  /// 이미지가 없을 때 표시할 위젯
  Widget _buildNoImages() {
    return const Center(child: Text('이미지가 없습니다'));
  }

  /// 이미지를 슬라이드하는 PageView
  Widget _buildImageCarousel() {
    return PageView.builder(
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        final imageUrl = imageList[index]['imageUri'];
        return _buildImage(imageUrl);
      },
    );
  }

  /// 이미지 위젯을 반환하는 메서드
  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }

  /// 컨테이너의 장식 설정
  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    );
  }
}
