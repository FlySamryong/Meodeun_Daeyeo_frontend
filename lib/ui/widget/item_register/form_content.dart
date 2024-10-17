import 'package:flutter/material.dart';
import 'photo_upload_box.dart';
import 'input_field.dart';
import 'description_field.dart';
import 'submit_button.dart';

// 물품 등록 폼 컨텐츠 위젯
class FormContentWidget extends StatelessWidget {
  final double scaleWidth;

  const FormContentWidget({required this.scaleWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15 * scaleWidth),
        child: Column(
          children: [
            PhotoUploadBoxWidget(scaleWidth: scaleWidth),
            const SizedBox(height: 15),
            InputFieldWidget(labelText: '물품명', scaleWidth: scaleWidth),
            const SizedBox(height: 10),
            InputFieldWidget(labelText: '거래 장소', scaleWidth: scaleWidth),
            const SizedBox(height: 10),
            InputFieldWidget(labelText: '1일 대여료', scaleWidth: scaleWidth),
            const SizedBox(height: 10),
            InputFieldWidget(labelText: '보증금', scaleWidth: scaleWidth),
            const SizedBox(height: 10),
            InputFieldWidget(labelText: '대여 가능 기간', scaleWidth: scaleWidth),
            const SizedBox(height: 10),
            InputFieldWidget(labelText: '물품 카테고리', scaleWidth: scaleWidth),
            const SizedBox(height: 20),
            DescriptionFieldWidget(scaleWidth: scaleWidth),
            const SizedBox(height: 20),
            SubmitButtonWidget(scaleWidth: scaleWidth),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
