import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config.dart';
import '../../../utils/show_error_dialog.dart';
import '../../../utils/token_storage.dart';
import '../../api_client.dart';
import '../dto/login_response_dto.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // 에러 메시지를 상수로 정의하여 코드 가독성 및 유지보수성을 향상시킵니다.
  static const String _loginFailureMessage = "로그인 실패";
  static const String _tokenInvalidMessage = "유효하지 않은 토큰입니다.";
  static const String _networkErrorMessage = "네트워크 오류";

  /// 액세스 토큰을 사용하여 로그인 처리
  /// 성공 시 사용자 ID와 토큰을 저장하고, 실패 시 에러 다이얼로그를 표시합니다.
  Future<LoginResponse?> loginWithAccessToken(
      String accessToken, BuildContext context) async {
    try {
      // API 클라이언트를 사용하여 로그인 요청을 보냅니다.
      final response = await _apiClient.getWithoutAuth(
        endpoint: 'auth/kakao/login?accessToken=$accessToken',
      );

      // JSON 응답을 파싱하여 데이터로 변환합니다.
      final data = await _parseJson(response.body);

      await Future.delayed(Duration(milliseconds: 100));

      // 로그인 성공 여부를 확인하고, 성공 시 로그인 처리를 진행합니다.
      if (response.statusCode == 200) {
        print('Login success: ${data['data']}');
        return await _handleLoginSuccess(data['data'], context);
      } else {
        print('Login failed: ${data['message']}');
        showErrorDialog(context, data['message'] ?? _loginFailureMessage);
      }
    } catch (error) {
      // 네트워크 오류 발생 시 에러 메시지를 다이얼로그로 표시합니다.
      _showNetworkError(context, error);
    }
    return null;
  }

  /// 로그인 성공 시 사용자 정보를 저장하고, 로그인 응답 객체를 반환합니다.
  Future<LoginResponse?> _handleLoginSuccess(
      Map<String, dynamic> data, BuildContext context) async {
    final loginResponse = await LoginResponse.fromJson(data);
    await TokenStorage.saveUserId(loginResponse.id);
    await TokenStorage.saveTokens(
        loginResponse.accessToken, loginResponse.refreshToken);
    return loginResponse;
  }

  /// 저장된 토큰이 유효한지 확인합니다.
  /// 유효하지 않은 경우 에러 다이얼로그를 표시하고, 유효하면 true를 반환합니다.
  Future<bool> isTokenValid(BuildContext context) async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) return false;

    try {
      // 유효성 검사를 위해 토큰을 포함한 HTTP GET 요청을 보냅니다.
      final response = await _checkTokenValidity(accessToken);
      if (response.statusCode == 200) {
        // 토큰이 유효한 경우 true 반환
        return true;
      } else {
        // 토큰이 유효하지 않은 경우 처리
        _handleTokenInvalid(response, context);
      }
    } catch (error) {
      // 네트워크 오류 발생 시 에러 메시지를 다이얼로그로 표시합니다.
      _showNetworkError(context, error);
    }
    return false;
  }

  /// 토큰 유효성을 확인하는 API 요청을 수행합니다.
  Future<http.Response> _checkTokenValidity(String accessToken) {
    return http.get(
      Uri.parse('${Config.baseUrl}/member/myPage'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': '*/*',
      },
    );
  }

  /// 토큰이 유효하지 않은 경우 에러 메시지를 표시합니다.
  void _handleTokenInvalid(http.Response response, BuildContext context) async {
    final data = await _parseJson(response.body);
    if (data['code'] == 'AUTH403') {
      showErrorDialog(context, data['message'] ?? _tokenInvalidMessage);
    }
  }

  /// JSON 문자열을 파싱하여 Map 형태로 반환합니다.
  Future<Map<String, dynamic>> _parseJson(String responseBody) async {
    return json.decode(responseBody);
  }

  /// 네트워크 오류 발생 시 에러 메시지를 표시합니다.
  void _showNetworkError(BuildContext context, Object error) {
    showErrorDialog(context, "$_networkErrorMessage: ${error.toString()}");
  }
}
