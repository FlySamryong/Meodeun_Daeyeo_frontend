import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class PhotoUploadBoxWidget extends StatefulWidget {
  final double scaleWidth;
  final Function(List<Uint8List>) onImagesSelected;

  const PhotoUploadBoxWidget({
    required this.scaleWidth,
    required this.onImagesSelected,
    super.key,
  });

  @override
  State<PhotoUploadBoxWidget> createState() => _PhotoUploadBoxWidgetState();
}

class _PhotoUploadBoxWidgetState extends State<PhotoUploadBoxWidget> {
  final List<Uint8List> uploadedImages = [];

  void _pickImages() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null) {
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          await reader.onLoadEnd.first;
          setState(() {
            uploadedImages.add(reader.result as Uint8List);
          });
        }

        // 부모 위젯으로 이미지 전달
        widget.onImagesSelected(uploadedImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 100 * widget.scaleWidth,
        height: 100 * widget.scaleWidth,
        color: Colors.grey[300],
        child: const Icon(Icons.add_a_photo, size: 50),
      ),
    );
  }
}