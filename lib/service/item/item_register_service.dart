import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_client.dart';

/// 아이템 등록 서비스
class ItemRegisterService {
  final ApiClient _apiClient = ApiClient();

  /// 아이템 등록 메서드
  Future<int> registerItem({
    required BuildContext context,
    required List<String> imageList,
    required Map<String, dynamic> itemDTO,
    required Map<String, dynamic> locationDTO,
  }) async {
    const String endpoint = 'item/create';

    // 요청 바디 생성
    final Map<String, dynamic> requestBody = {
      'imageList': imageList,
      'itemDTO': itemDTO,
      'locationDTO': locationDTO,
    };

    try {
      // API POST 요청 수행
      final response = await _apiClient.post(
        endpoint: endpoint,
        body: requestBody,
        context: context,
      );

      // 응답 상태 코드 확인
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['isSuccess']) {
          return responseData['data']; // 성공적으로 생성된 ID 반환
        } else {
          throw Exception(responseData['message'] ?? '아이템 등록 실패');
        }
      } else {
        throw Exception('HTTP 오류 발생: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('아이템 등록 중 오류: $e');
      throw Exception('아이템 등록 실패: $e');
    }
  }
}