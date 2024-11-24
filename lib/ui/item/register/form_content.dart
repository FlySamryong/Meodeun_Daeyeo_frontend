import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'field/photo_upload_box.dart';
import 'field/input_field.dart';
import 'field/description_field.dart';
import 'field/submit_button.dart';

/// 물품 등록 폼 컨텐츠 위젯
class FormContentWidget extends StatefulWidget {
  final double scaleWidth;
  final Function(Map<String, dynamic>) onSubmit; // 제출 콜백 추가

  const FormContentWidget({
    required this.scaleWidth,
    required this.onSubmit,
    super.key,
  });

  @override
  State<FormContentWidget> createState() => _FormContentWidgetState();
}

class _FormContentWidgetState extends State<FormContentWidget> {
  // 입력 필드 컨트롤러
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // 추가 상태
  final List<String> categories = [];
  final List<Uint8List> images = []; // Uint8List로 이미지 데이터 관리

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15 * widget.scaleWidth),
        child: Column(
          children: [
            _buildSelectedImages(), // 이미지 미리보기 위젯
            const SizedBox(height: 15),
            _buildPhotoUploadBox(), // 업로드 버튼 아래로 이동
            const SizedBox(height: 15),
            _buildInputField('물품명', nameController),
            const SizedBox(height: 10),
            _buildInputField('거래 장소', locationController),
            const SizedBox(height: 10),
            _buildInputField('1일 대여료', feeController, isNumber: true),
            const SizedBox(height: 10),
            _buildInputField('보증금', depositController, isNumber: true),
            const SizedBox(height: 10),
            _buildInputField('대여 가능 기간', periodController, isNumber: true),
            const SizedBox(height: 10),
            _buildInputField('물품 카테고리', null, isCategory: true),
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

  /// 선택된 이미지를 표시하는 위젯
  Widget _buildSelectedImages() {
    if (images.isEmpty) {
      return const Text(
        '이미지가 없습니다.',
        style: TextStyle(fontSize: 16),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      // GridView가 스크롤 영역을 차지하지 않도록 설정
      physics: const NeverScrollableScrollPhysics(),
      // 부모 스크롤에만 의존
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 표시할 이미지 개수
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            // 이미지 표시
            Image.memory(
              images[index], // Uint8List 데이터를 직접 사용
              width: 100 * widget.scaleWidth,
              height: 100 * widget.scaleWidth,
              fit: BoxFit.cover,
            ),
            // 삭제 버튼
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    images.removeAt(index); // 해당 이미지를 리스트에서 제거
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red, // 빨간색 배경
                    shape: BoxShape.circle, // 원형 버튼
                  ),
                  child: const Icon(
                    Icons.close, // 닫기 아이콘
                    color: Colors.white, // 흰색 아이콘
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 사진 업로드 박스 빌드
  Widget _buildPhotoUploadBox() {
    return PhotoUploadBoxWidget(
      scaleWidth: widget.scaleWidth,
      onImagesSelected: (selectedImages) {
        setState(() {
          images.clear(); // 기존 이미지 삭제
          images.addAll(selectedImages); // 새로 선택된 이미지 추가
        });
      },
    );
  }

  /// 입력 필드 빌드
  Widget _buildInputField(String labelText,
      TextEditingController? controller, {
        bool isNumber = false,
        bool isCategory = false,
      }) {
    if (isCategory) {
      return InputFieldWidget(
        labelText: labelText,
        scaleWidth: widget.scaleWidth,
        onValueChanged: (value) {
          setState(() {
            if (value.isNotEmpty) categories.add(value);
          });
        },
      );
    }
    return InputFieldWidget(
      labelText: labelText,
      scaleWidth: widget.scaleWidth,
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  /// 물품 설명 필드 빌드
  Widget _buildDescriptionField() {
    return DescriptionFieldWidget(
      scaleWidth: widget.scaleWidth,
      controller: descriptionController,
    );
  }

  /// 제출 버튼 빌드
  Widget _buildSubmitButton() {
    return SubmitButtonWidget(
      scaleWidth: widget.scaleWidth,
      onPressed: _submitForm,
    );
  }

  /// 폼 제출 함수
  void _submitForm() {
    final formData = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'period': int.tryParse(periodController.text.trim()) ?? 0,
      'fee': int.tryParse(feeController.text.trim()) ?? 0,
      'deposit': int.tryParse(depositController.text.trim()) ?? 0,
      'location': locationController.text.trim(),
      'categories': categories,
      'images': images,
    };

    print('폼 데이터: $formData');

    // 필수 입력값 체크
    if (((formData['name'] as String?)?.isEmpty ?? true) ||
        ((formData['location'] as String?)?.isEmpty ?? true)) {
      print('필수 입력값 누락!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 입력값을 확인해주세요!')),
      );
      return;
    }

    widget.onSubmit(formData);
  }
}