import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/token_storage.dart';
import '../../../utils/show_error_dialog.dart';

class ApiClient {
  final String _baseUrl = 'http://54.180.28.151:8080/api';

  // 에러 메시지 상수 정의
  static const String _sessionExpiredMessage = '로그인 세션이 만료되었습니다. 다시 로그인해 주세요.';
  static const String _tokenRefreshErrorMessage = '토큰 갱신 중 오류가 발생했습니다.';
  static const String _expiredTokenMessage = '만료된 토큰입니다.';

  /// Access Token 갱신 메서드
  Future<String?> _refreshAccessToken(BuildContext context) async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return null;

    final refreshUrl = Uri.parse('$_baseUrl/auth/kakao/reissue');
    try {
      final response = await http.post(
        refreshUrl,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(refreshToken),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newAccessToken = responseData['accessToken'];
        final newRefreshToken = responseData['refreshToken'];

        // 새 토큰 저장
        await TokenStorage.saveTokens(newAccessToken, newRefreshToken);
        return newAccessToken;
      } else {
        _handleSessionExpiry(context);
        return null;
      }
    } catch (e) {
      showErrorDialog(context, _tokenRefreshErrorMessage);
      return null;
    }
  }

  /// 기본 POST 요청 메서드
  Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    required BuildContext context,
    bool retryOnAuthFail = true,
  }) async {
    return await _sendAuthenticatedRequest(
      endpoint: endpoint,
      context: context,
      retryOnAuthFail: retryOnAuthFail,
      method: 'POST',
      body: body,
    );
  }

  /// 기본 GET 요청 메서드
  Future<http.Response> get({
    required String endpoint,
    required BuildContext context,
    bool retryOnAuthFail = true,
  }) async {
    return await _sendAuthenticatedRequest(
      endpoint: endpoint,
      context: context,
      retryOnAuthFail: retryOnAuthFail,
      method: 'GET',
    );
  }

  // 인증 없이 GET 요청을 보내는 메서드
  Future<http.Response> getWithoutAuth({
    required String endpoint,
  }) async {
    Uri url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
    };

    return await http.get(url, headers: headers);
  }

  /// 인증된 요청을 처리하고, 필요 시 토큰 갱신 후 재시도하는 메서드
  Future<http.Response> _sendAuthenticatedRequest({
    required String endpoint,
    required BuildContext context,
    bool retryOnAuthFail = true,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    String? accessToken = await TokenStorage.getAccessToken();
    Uri url = Uri.parse('$_baseUrl/$endpoint');

    // 초기 요청 전송
    http.Response response = await _sendRequest(
      url,
      accessToken!,
      method,
      body: body,
    );

    // 토큰 만료 확인 및 갱신 처리
    if (_isTokenExpired(response) && retryOnAuthFail) {
      accessToken = await _refreshAccessToken(context);

      if (accessToken != null) {
        // 갱신된 토큰으로 재시도
        response = await _sendRequest(url, accessToken, method, body: body);
      } else {
        // 갱신 실패 시 로그인 화면으로 리다이렉트
        _handleSessionExpiry(context);
      }
    }

    return response;
  }

  /// HTTP 요청 전송 메서드 (POST, GET 등)
  Future<http.Response> _sendRequest(
    Uri url,
    String accessToken,
    String method, {
    Map<String, dynamic>? body,
  }) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    late http.Response response;
    if (method == 'POST') {
      response = await http.post(url, headers: headers, body: jsonEncode(body));
    } else {
      response = await http.get(url, headers: headers);
    }

    return response;
  }

  /// 토큰 만료 확인 메서드
  bool _isTokenExpired(http.Response response) {
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    return responseData['message'] == _expiredTokenMessage;
  }

  /// 세션 만료 시 다이얼로그를 표시하고 로그인 화면으로 리다이렉트하는 메서드
  void _handleSessionExpiry(BuildContext context) {
    showErrorDialog(context, _sessionExpiredMessage);
    Navigator.pushReplacementNamed(context, '/login');
  }
}
