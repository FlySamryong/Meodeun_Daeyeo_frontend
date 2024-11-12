import 'package:flutter/material.dart';

/// 사진 업로드 박스 위젯
class PhotoUploadBoxWidget extends StatelessWidget {
  final double scaleWidth;

  const PhotoUploadBoxWidget({required this.scaleWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150 * scaleWidth,
      decoration: _buildBoxDecoration(),
      child: Center(
        child: _buildIcon(),
      ),
    );
  }

  /// 박스의 장식 스타일을 반환하는 함수
  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
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
    );
  }

  /// 아이콘을 반환하는 함수
  Widget _buildIcon() {
    return Icon(
      Icons.add_a_photo,
      size: 50 * scaleWidth,
      color: Colors.grey,
    );
  }
}
