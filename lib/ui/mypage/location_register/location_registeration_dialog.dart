import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../service/api_client.dart';
import '../../../utils/show_error_dialog.dart';

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
  final ApiClient _apiClient = ApiClient(); // ApiClient 인스턴스 생성
  final Color primaryColor = const Color(0xFF079702).withOpacity(0.95); // 초록색

  // 드롭다운 선택 값 초기화
  String selectedCity = "서울시";
  String selectedDistrict = "강남구";
  String selectedNeighborhood = "삼성동";

  /// 드롭다운 데이터
  final List<String> cities = ["서울시", "부산시", "대구시"];
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
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      title: const Text(
        "거주지 등록",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "등록할 거주지를 선택해주세요.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
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
              iconEnabledColor: primaryColor,
            ),
            const SizedBox(height: 10),
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
            SizedBox(
              width: 100,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                ),
                child: const Text("취소"),
              ),
            ),
            const SizedBox(width: 10),
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

  /// 확인 버튼 클릭 시 서버에 POST 요청
  Future<void> _handleConfirmButtonPressed() async {
    final selectedLocation = {
      "city": selectedCity,
      "district": selectedDistrict,
      "neighborhood": selectedNeighborhood,
    };

    try {
      // 서버로 POST 요청
      final response = await _apiClient.post(
        endpoint: 'member/register/location',
        body: selectedLocation,
        context: context,
      );

      if (response.statusCode == 200) {
        // 성공 메시지 처리
        Navigator.pop(context, selectedLocation);
        print("거주지 등록 성공: ${response.body}");
      } else {
        // 오류 메시지 처리 (UTF-8 디코딩 추가)
        final responseBody = utf8.decode(response.bodyBytes); // 디코딩
        final errorMessage = jsonDecode(responseBody)['message'] ?? "등록 실패";
        showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      // 예외 처리
      showErrorDialog(context, "네트워크 오류가 발생했습니다.");
    }
  }
}