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

  // 드롭다운 데이터
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
    }
  };

  String? selectedCity; // 선택된 도시
  String? selectedDistrict; // 선택된 구
  String? selectedNeighborhood; // 선택된 동

  List<String> get cityList => _locations.keys.toList();

  List<String> get districtList =>
      selectedCity != null ? _locations[selectedCity!]!.keys.toList() : [];

  List<String> get neighborhoodList =>
      selectedCity != null && selectedDistrict != null
          ? _locations[selectedCity!]![selectedDistrict!] ?? []
          : [];

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
            // 도시 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cityList
                  .map((city) =>
                      DropdownMenuItem(value: city, child: Text(city)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  selectedDistrict = null;
                  selectedNeighborhood = null; // 초기화
                });
              },
              decoration:
                  _buildInputDecoration(hintText: '', labelText: '도시 선택'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: primaryColor,
            ),
            const SizedBox(height: 10),
            // 구 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: districtList
                  .map((district) =>
                      DropdownMenuItem(value: district, child: Text(district)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedNeighborhood = null; // 초기화
                });
              },
              decoration:
                  _buildInputDecoration(hintText: '', labelText: '구 선택'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: primaryColor,
            ),
            const SizedBox(height: 10),
            // 동 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedNeighborhood,
              items: neighborhoodList
                  .map((neighborhood) => DropdownMenuItem(
                      value: neighborhood, child: Text(neighborhood)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedNeighborhood = value;
                });
              },
              decoration:
                  _buildInputDecoration(hintText: '', labelText: '동 선택'),
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
    if (selectedCity == null ||
        selectedDistrict == null ||
        selectedNeighborhood == null) {
      showErrorDialog(context, "모든 항목을 선택해주세요.");
      return;
    }

    final selectedLocation = {
      "city": selectedCity!,
      "district": selectedDistrict!,
      "neighborhood": selectedNeighborhood!,
    };

    try {
      // 서버로 POST 요청
      final response = await _apiClient.post(
        endpoint: 'member/register/location',
        body: selectedLocation,
        context: context,
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, selectedLocation); // 성공 시 선택한 데이터를 반환
      } else {
        final responseBody = utf8.decode(response.bodyBytes); // 디코딩
        final errorMessage = jsonDecode(responseBody)['message'] ?? "등록 실패";
        showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      showErrorDialog(context, "네트워크 오류가 발생했습니다.");
    }
  }
}
