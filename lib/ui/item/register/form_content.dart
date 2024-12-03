import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:typed_data';
import 'dart:html';
import '../../../service/item/item_register_service.dart';
import '../../../utils/show_error_dialog.dart';
import '../../home/main_page.dart';

class FormContentWidget extends StatefulWidget {
  final double scaleWidth;

  const FormContentWidget({required this.scaleWidth, super.key});

  @override
  State<FormContentWidget> createState() => _FormContentWidgetState();
}

class _FormContentWidgetState extends State<FormContentWidget> {
  final ItemRegisterService _itemService = ItemRegisterService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedNeighborhood;

  final List<Uint8List> _imageFiles = [];
  final List<String> _categories = [
    "전자제품",
    "의류",
    "도서",
    "생활용품",
    "가구",
    "스포츠",
    "미용"
  ];

  final Map<String, Map<String, List<String>>> _locations = {
    "서울시": {
      "강남구": ["역삼동", "청담동", "삼성동"],
      "서초구": ["서초동", "방배동", "반포동"],
      "송파구": ["잠실동", "문정동", "가락동"]
    },
    "부산시": {
      "해운대구": ["우동", "재송동", "좌동"],
      "부산진구": ["부암동", "전포동", "당감동"],
      "사하구": ["하단동", "구평동", "다대동"]
    },
    "대구시": {
      "수성구": ["범어동", "지산동", "파동"],
      "달서구": ["월성동", "용산동", "상인동"],
      "중구": ["동인동", "대봉동", "남산동"]
    },
    "인천시": {
      "남동구": ["구월동", "만수동", "서창동"],
      "연수구": ["송도동", "연수동", "동춘동"],
      "부평구": ["부평동", "산곡동", "삼산동"]
    },
    "광주시": {
      "북구": ["문흥동", "운암동", "용봉동"],
      "남구": ["봉선동", "진월동", "주월동"],
      "서구": ["화정동", "치평동", "금호동"]
    },
    "대전시": {
      "유성구": ["봉명동", "노은동", "지족동"],
      "서구": ["둔산동", "갈마동", "월평동"],
      "중구": ["대흥동", "태평동", "문화동"]
    },
    "안양시": {
      "동안구": ["평촌동", "호계동", "범계동"],
      "만안구": ["안양동", "석수동", "박달동"]
    },
    "고양시": {
      "일산동구": ["백석동", "마두동", "장항동"],
      "덕양구": ["화정동", "행신동", "주교동"],
      "일산서구": ["탄현동", "대화동", "주엽동"]
    },
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15 * widget.scaleWidth),
        child: Column(
          children: [
            _buildPhotoUploadBox(),
            const SizedBox(height: 15),
            _buildDropdownField('카테고리', _categories, _selectedCategory,
                (value) {
              setState(() {
                _selectedCategory = value;
              });
            }),
            const SizedBox(height: 15),
            _buildDropdownLocation(),
            const SizedBox(height: 15),
            _buildInputField('물품명', '예: 고성능 노트북', _nameController),
            const SizedBox(height: 10),
            _buildInputField('1일 대여료', '예: 5000', _feeController,
                isNumeric: true),
            const SizedBox(height: 10),
            _buildInputField('보증금', '예: 20000', _depositController,
                isNumeric: true),
            const SizedBox(height: 10),
            _buildInputField('대여 가능 기간', '예: 3 (3일)', _periodController,
                isNumeric: true),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// 드롭다운 필드 위젯을 생성하는 메서드
  Widget _buildDropdownField(String label, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.green),
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.green, // 초록색 라벨
        ),
      ),
      dropdownColor: Colors.white,
      // 드랍박스 배경 흰색
      style: const TextStyle(color: Colors.black),
      // 텍스트 색상
      value: selectedValue,
      onChanged: onChanged,
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }

  /// 입력 필드 위젯을 생성하는 메서드
  Widget _buildInputField(
      String label, String hint, TextEditingController controller,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      textAlignVertical: TextAlignVertical.top, // 텍스트 상단 정렬
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.green), // 초록색 강조선
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.green, // 초록색 라벨
        ),
      ),
    );
  }

  /// 설명 필드 위젯을 생성하는 메서드
  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 5,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        labelText: '물품 설명',
        hintText: '예: 이 노트북은 최신형이며 고사양 게임도 가능해요.',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.green,
        ),
      ),
    );
  }

  /// 위치 선택 드롭다운 위젯을 생성하는 메서드
  Widget _buildDropdownLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField('시/도', _locations.keys.toList(), _selectedCity,
            (value) {
          setState(() {
            _selectedCity = value;
            _selectedDistrict = null;
            _selectedNeighborhood = null;
          });
        }),
        const SizedBox(height: 15),
        if (_selectedCity != null)
          _buildDropdownField(
            '구/군',
            _locations[_selectedCity]?.keys.toList() ?? [],
            _selectedDistrict,
            (value) {
              setState(() {
                _selectedDistrict = value;
                _selectedNeighborhood = null;
              });
            },
          ),
        const SizedBox(height: 15),
        if (_selectedDistrict != null)
          _buildDropdownField(
            '동',
            _locations[_selectedCity]?[_selectedDistrict] ?? [],
            _selectedNeighborhood,
            (value) {
              setState(() {
                _selectedNeighborhood = value;
              });
            },
          ),
      ],
    );
  }

  /// 등록하기 버튼 위젯을 생성하는 메서드
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        '등록하기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 사진 업로드 박스 위젯을 생성하는 메서드
  Widget _buildPhotoUploadBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ..._imageFiles.map((file) {
              return Stack(
                children: [
                  Image.memory(
                    file,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _imageFiles.remove(file);
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_a_photo, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 이미지 선택 다이얼로그를 띄우는 메서드
  Future<void> _pickImage() async {
    final uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          _imageFiles.add(reader.result as Uint8List);
        });
      });
    });
  }

  /// 폼 제출 메서드
  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ||
        _feeController.text.isEmpty ||
        _depositController.text.isEmpty ||
        _periodController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedCity == null ||
        _selectedDistrict == null ||
        _selectedNeighborhood == null) {
      showErrorDialog(context, '모든 필드를 채워주세요.');
      return;
    }

    final itemDTO = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'period': int.tryParse(_periodController.text) ?? 1,
      'fee': int.tryParse(_feeController.text) ?? 0,
      'deposit': int.tryParse(_depositController.text) ?? 0,
      'categoryList': [
        {'name': _selectedCategory}
      ],
    };

    final locationDTO = {
      'city': _selectedCity,
      'district': _selectedDistrict,
      'neighborhood': _selectedNeighborhood,
    };

    final success = await _itemService.registerItem(
      context: context,
      imageFiles: _imageFiles,
      itemDTO: itemDTO,
      locationDTO: locationDTO,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveBuilder(
            builder: (context, sizingInformation) =>
                MainPage(sizingInformation: sizingInformation),
          ),
        ),
      );
    }
  }
}
