import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_client.dart';

/// 최근 본 물품 서비스
class RecentViewItemService {
  final ApiClient _apiClient = ApiClient();

  /// 최근 본 물품 목록 가져오기
  Future<List<Map<String, dynamic>>> fetchRecentItems(
      BuildContext context) async {
    try {
      // API 요청
      final response = await _apiClient.get(
        endpoint: 'item/recent',
        context: context,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));

        // 응답이 성공인지 확인
        if (responseData['isSuccess'] == true) {
          final itemList = responseData['data']['itemList'] as List;
          return itemList.map((item) => item as Map<String, dynamic>).toList();
        } else {
          throw Exception(responseData['message'] ?? '알 수 없는 오류가 발생했습니다.');
        }
      } else {
        throw Exception('요청 실패: 상태 코드 ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('데이터를 가져오는 중 오류가 발생했습니다: $e');
    }
  }
}
