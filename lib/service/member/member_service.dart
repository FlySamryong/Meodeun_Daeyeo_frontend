import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/show_error_dialog.dart';
import '../api_client.dart';

/// 멤버 서비스
class MemberService {
  final ApiClient _apiClient = ApiClient();

  /// 공통 GET 요청 처리
  Future<Map<String, dynamic>> _sendGetRequest({
    required BuildContext context,
    required String endpoint,
    String? defaultErrorMessage,
  }) async {
    try {
      final response = await _apiClient.get(
        endpoint: endpoint,
        context: context,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorResponse['message'] ?? defaultErrorMessage;
        throw Exception(errorMessage ?? '요청 처리 중 오류 발생');
      }
    } catch (e) {
      debugPrint('API 요청 오류: $e');
      throw Exception(e.toString());
    }
  }

  /// 대여 목록 조회 API 호출
  Future<List<dynamic>> fetchRentalList(BuildContext context) async {
    final endpoint = 'member/myRentOrLoanList';
    final response = await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: '대여 목록 조회 실패',
    );

    print(response['data']['rentOrLoanList']);

    return response['data']['rentOrLoanList'] as List<dynamic>;
  }

  /// 관심 아이템 목록 조회 API 호출
  Future<List<dynamic>> fetchFavoriteItems(BuildContext context) async {
    const endpoint = 'item/wishList'; // 요청할 엔드포인트
    final response = await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: '관심 아이템 목록 조회 실패',
    );

    // 관심 아이템 리스트 반환
    return response['data']['itemPreviewResponseDTOList'] as List<dynamic>;
  }

  /// 관심 목록 추가 GET 요청
  Future<void> addToWishList({
    required BuildContext context,
    required int itemId,
  }) async {
    final endpoint = 'member/wishList/$itemId'; // GET 요청 엔드포인트
    try {
      final response = await _apiClient.get(
        endpoint: endpoint,
        context: context,
      );

      if (response.statusCode == 200) {
        // 성공 시 아무런 동작도 수행하지 않음
      } else {
        final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorResponse['message'] ?? '관심 목록 추가 실패';
        showErrorDialog(context, errorMessage); // 실패 시 다이얼로그 표시
      }
    } catch (e) {
      debugPrint('관심 목록 추가 오류: $e');
    }
  }

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
