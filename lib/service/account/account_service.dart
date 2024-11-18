import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../api_client.dart';

/// 계좌 서비스
class AccountService {
  final ApiClient _apiClient = ApiClient();

  /// 계좌 등록 API 호출
  Future<bool> registerAccount({
    required BuildContext context,
    required String accountNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        endpoint: 'member/register/account/nh',
        body: {'accountNumber': accountNumber},
        context: context,
      );

      // 성공 상태 코드 처리
      if (response.statusCode == 200) {
        return true;
      }

      // 오류 메시지 추출
      throw Exception(_extractErrorMessage(response));
    } catch (e) {
      throw Exception(_formatError(e));
    }
  }

  /// 서버 응답에서 오류 메시지 추출
  String _extractErrorMessage(response) {
    const defaultErrorMessage = "알 수 없는 오류가 발생했습니다.";
    try {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedBody['message'] ?? defaultErrorMessage;
    } catch (e) {
      return defaultErrorMessage;
    }
  }

  /// 예외 메시지 포맷팅
  String _formatError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll("Exception: ", "");
    }
    return "알 수 없는 오류가 발생했습니다.";
  }
}
