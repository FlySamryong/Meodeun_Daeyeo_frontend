import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../utils/show_error_dialog.dart';
import '../api_client.dart';

class ItemService {
  final ApiClient _apiClient = ApiClient();

  // 에러 메시지 상수 정의
  static const String _unknownErrorMessage = '알 수 없는 오류가 발생했습니다.';
  static const String _itemNotFoundErrorMessage = 'ITEM404: 해당 아이템을 찾을 수 없습니다.';
  static const String _fetchErrorMessage = 'Failed to load item details';

  /// 아이템 세부 정보를 가져오는 메서드
  /// 성공 시 데이터 반환, 실패 시 에러를 발생시킵니다.
  Future<Map<String, dynamic>> fetchItemDetails({
    required int itemId,
    required BuildContext context,
  }) async {
    try {
      // 아이템 세부 정보 API 요청
      final response = await _apiClient.get(
        endpoint: 'item/$itemId',
        context: context,
      );

      // 상태 코드에 따라 응답 처리
      if (response.statusCode == 200) {
        final result = _parseResponse(response.bodyBytes);
        if (result['isSuccess']) {
          return result['data']; // 성공 시 데이터 반환
        } else {
          // 실패 시 에러 다이얼로그 표시 및 예외 발생
          return _showErrorAndThrow(
              context, result['message'] ?? _unknownErrorMessage);
        }
      } else if (response.statusCode == 404) {
        // 404 오류인 경우 사용자에게 아이템을 찾을 수 없다는 메시지 표시
        return _showErrorAndThrow(context, _itemNotFoundErrorMessage);
      } else {
        // 기타 오류인 경우 기본 에러 메시지 사용
        return _showErrorAndThrow(context, _fetchErrorMessage);
      }
    } catch (e) {
      // 네트워크 또는 기타 예외 발생 시 에러 메시지 표시
      return _showErrorAndThrow(context, '$_fetchErrorMessage: $e');
    }
  }

  /// 응답 데이터를 JSON 형태로 파싱하여 반환하는 헬퍼 메서드
  Map<String, dynamic> _parseResponse(Uint8List bodyBytes) {
    return jsonDecode(utf8.decode(bodyBytes));
  }

  /// 에러 메시지를 다이얼로그로 표시하고 예외를 발생시키는 헬퍼 메서드
  Map<String, dynamic> _showErrorAndThrow(
      BuildContext context, String message) {
    showErrorDialog(context, message);
    throw Exception(message); // 예외 발생
  }
}
