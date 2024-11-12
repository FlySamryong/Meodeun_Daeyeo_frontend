import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../utils/show_error_dialog.dart';
import '../api_client.dart';

class ItemService {
  final ApiClient _apiClient = ApiClient();

  // 에러 메시지 상수 정의
  static const String _unknownErrorMessage = '알 수 없는 오류가 발생했습니다.';
  static const String _fetchErrorMessage = '아이템을 가져오는 중 오류가 발생했습니다.';

  /// 아이템 목록을 가져오는 메서드
  Future<Map<String, dynamic>> fetchItems({
    required BuildContext context,
    int page = 0,
    String keyword = "",
    String category = "",
    String location = "",
  }) async {
    // API 요청의 엔드포인트 정의
    final endpoint = 'item/search?page=$page';

    // 요청 본문 구성
    final body = {
      "keyword": keyword.isNotEmpty ? keyword : null,
      "category": category.isNotEmpty ? {"name": category} : null,
      "location": _parseLocation(location),
    };

    try {
      // API 요청 전송
      final response = await _apiClient.post(
        endpoint: endpoint,
        body: body,
        context: context,
      );

      // 응답 데이터 파싱 및 검증
      return _parseResponse(response.bodyBytes, context);
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      showErrorDialog(context, _fetchErrorMessage);
      return {'items': []};
    }
  }

  /// 위치 정보를 파싱하여 필요한 형식으로 반환
  Map<String, String?>? _parseLocation(String location) {
    if (location.isNotEmpty && location.contains(",")) {
      final parts = location.split(",");
      return {
        "city": parts[0],
        "district": parts.length > 1 ? parts[1] : null,
        "neighborhood": parts.length > 2 ? parts[2] : null,
      };
    }
    return null;
  }

  /// 응답 데이터를 파싱하고 성공 여부를 검증하여 필요한 데이터를 반환
  Map<String, dynamic> _parseResponse(
      Uint8List bodyBytes, BuildContext context) {
    final responseData = jsonDecode(utf8.decode(bodyBytes));
    print('fetchItems: $responseData');

    if (responseData['isSuccess'] == true &&
        responseData['data'] is Map<String, dynamic> &&
        responseData['data']['itemPreviewResponseDTOList'] is List) {
      final data = responseData['data'];
      return {
        'items': data['itemPreviewResponseDTOList'],
        'currentElement': data['currentElement'],
        'totalPage': data['totalPage'],
        'totalElement': data['totalElement'],
      };
    } else {
      showErrorDialog(context, responseData['message'] ?? _unknownErrorMessage);
      return {'items': []};
    }
  }
}
