import 'package:flutter/material.dart';

/// 거주지 등록 다이얼로그
class LocationRegistrationDialog extends StatefulWidget {
  final BuildContext parentContext;

  const LocationRegistrationDialog({
    Key? key,
    required this.parentContext,
  }) : super(key: key);

  @override
  _LocationRegistrationDialogState createState() =>
      _LocationRegistrationDialogState();
}

class _LocationRegistrationDialogState
    extends State<LocationRegistrationDialog> {
  final Color primaryColor = const Color(0xFF079702).withOpacity(0.95); // 초록색

  // 드롭다운 선택 값 초기화
  String selectedCity = "서울특별시";
  String selectedDistrict = "강남구";
  String selectedNeighborhood = "삼성동";

  /// 드롭다운 데이터
  final List<String> cities = ["서울특별시", "부산광역시", "대구광역시"];
  final List<String> districts = ["강남구", "중구", "서초구"];
  final List<String> neighborhoods = ["삼성동", "역삼동", "논현동"];

  /// 공통 InputDecoration 스타일 함수
  InputDecoration _buildInputDecoration({
    required String hintText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: primaryColor),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }

  /// 공통 버튼 스타일링 함수
  ButtonStyle _buildButtonStyle({required Color backgroundColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      // 다이얼로그 배경색
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      title: const Text(
        "거주지 등록",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400, // 다이얼로그 가로 크기
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용 크기에 맞게 다이얼로그 크기 조정
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "등록할 거주지를 선택해주세요.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            // 도 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities
                  .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                });
              },
              decoration: _buildInputDecoration(hintText: '', labelText: '도 선택'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: primaryColor, // 드롭다운 아이콘 색상
            ),
            const SizedBox(height: 10),
            // 시 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: districts
                  .map((district) =>
                  DropdownMenuItem(value: district, child: Text(district)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value!;
                });
              },
              decoration: _buildInputDecoration(hintText: '', labelText: '시 선택'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: primaryColor,
            ),
            const SizedBox(height: 10),
            // 동 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedNeighborhood,
              items: neighborhoods
                  .map((neighborhood) => DropdownMenuItem(
                  value: neighborhood, child: Text(neighborhood)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedNeighborhood = value!;
                });
              },
              decoration: _buildInputDecoration(hintText: '', labelText: '동 선택'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: primaryColor,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 취소 버튼
            SizedBox(
              width: 100, // 버튼 가로 크기
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                ),
                child: const Text("취소"),
              ),
            ),
            const SizedBox(width: 10), // 버튼 간격
            // 확인 버튼
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: _handleConfirmButtonPressed,
                style: _buildButtonStyle(backgroundColor: primaryColor),
                child: const Text("확인"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 확인 버튼 클릭 시 실행될 함수
  void _handleConfirmButtonPressed() {
    final selectedLocation = {
      "city": selectedCity,
      "district": selectedDistrict,
      "neighborhood": selectedNeighborhood,
    };

    // 예시: 콘솔에 출력
    print("선택된 거주지: $selectedLocation");

    Navigator.pop(context, selectedLocation); // 선택된 데이터를 반환하고 다이얼로그 닫기
  }
}