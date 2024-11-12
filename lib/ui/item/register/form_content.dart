import 'package:flutter/material.dart';
import 'field/photo_upload_box.dart';
import 'field/input_field.dart';
import 'field/description_field.dart';
import 'field/submit_button.dart';

/// 물품 등록 폼 컨텐츠 위젯
class FormContentWidget extends StatelessWidget {
  final double scaleWidth;

  const FormContentWidget({required this.scaleWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15 * scaleWidth),
        child: Column(
          children: [
            _buildPhotoUploadBox(),
            const SizedBox(height: 15),
            _buildInputField('물품명'),
            const SizedBox(height: 10),
            _buildInputField('거래 장소'),
            const SizedBox(height: 10),
            _buildInputField('1일 대여료'),
            const SizedBox(height: 10),
            _buildInputField('보증금'),
            const SizedBox(height: 10),
            _buildInputField('대여 가능 기간'),
            const SizedBox(height: 10),
            _buildInputField('물품 카테고리'),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 사진 업로드 박스 빌드
  Widget _buildPhotoUploadBox() {
    return PhotoUploadBoxWidget(scaleWidth: scaleWidth);
  }

  /// 입력 필드 빌드
  Widget _buildInputField(String labelText) {
    return InputFieldWidget(labelText: labelText, scaleWidth: scaleWidth);
  }

  /// 물품 설명 필드 빌드
  Widget _buildDescriptionField() {
    return DescriptionFieldWidget(scaleWidth: scaleWidth);
  }

  /// 제출 버튼 빌드
  Widget _buildSubmitButton() {
    return SubmitButtonWidget(scaleWidth: scaleWidth);
  }
}
