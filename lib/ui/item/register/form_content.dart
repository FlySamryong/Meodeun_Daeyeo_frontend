import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'field/description_field.dart';
import 'field/input_field.dart';
import 'field/photo_upload_box.dart';
import 'field/submit_button.dart';

/// 물품 등록 폼 컨텐츠 위젯
class FormContentWidget extends StatefulWidget {
  final double scaleWidth;
  final Function(Map<String, dynamic> formData) onSubmit; // 단일 formData 전달

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
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // 추가 상태
  final List<String> categories = [];
  final List<String> images = []; // Base64로 처리된 문자열 리스트

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15 * widget.scaleWidth),
        child: Column(
          children: [
            _buildSelectedImages(),
            const SizedBox(height: 15),
            _buildPhotoUploadBox(),
            const SizedBox(height: 15),
            _buildInputField('물품명', nameController),
            const SizedBox(height: 10),
            _buildInputField('도시', cityController),
            const SizedBox(height: 10),
            _buildInputField('구', districtController),
            const SizedBox(height: 10),
            _buildInputField('동', neighborhoodController),
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

  Widget _buildSelectedImages() {
    if (images.isEmpty) {
      return const Text('이미지가 없습니다.', style: TextStyle(fontSize: 16));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.memory(
              base64Decode(images[index]),
              width: 100 * widget.scaleWidth,
              height: 100 * widget.scaleWidth,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    images.removeAt(index);
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhotoUploadBox() {
    return PhotoUploadBoxWidget(
      scaleWidth: widget.scaleWidth,
      onImagesSelected: (selectedImages) {
        setState(() {
          images.clear();
          images.addAll(selectedImages.map((image) => base64Encode(image as Uint8List)));
        });
      },
    );
  }

  Widget _buildInputField(String labelText, TextEditingController? controller,
      {bool isNumber = false, bool isCategory = false}) {
    if (isCategory) {
      return InputFieldWidget(
        labelText: labelText,
        scaleWidth: widget.scaleWidth,
        onValueChanged: (value) {
          setState(() {
            if (value.isNotEmpty && !categories.contains(value)) {
              categories.add(value);
            }
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

  Widget _buildDescriptionField() {
    return DescriptionFieldWidget(
      scaleWidth: widget.scaleWidth,
      controller: descriptionController,
    );
  }

  Widget _buildSubmitButton() {
    return SubmitButtonWidget(
      scaleWidth: widget.scaleWidth,
      onPressed: _submitForm,
    );
  }

  void _submitForm() {
    if (nameController.text.isEmpty || cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 입력값을 확인해주세요!')),
      );
      return;
    }

    final locationDTO = {
      'city': cityController.text.trim(),
      'district': districtController.text.trim(),
      'neighborhood': neighborhoodController.text.trim(),
    };

    final categoryList = categories.map((name) => {'name': name}).toList();

    final formData = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'period': int.tryParse(periodController.text.trim()) ?? 0,
      'fee': int.tryParse(feeController.text.trim()) ?? 0,
      'deposit': int.tryParse(depositController.text.trim()) ?? 0,
      'locationDTO': locationDTO,
      'categoryList': categoryList,
      'imageList': images,
    };

    widget.onSubmit(formData);
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    districtController.dispose();
    neighborhoodController.dispose();
    feeController.dispose();
    depositController.dispose();
    periodController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}