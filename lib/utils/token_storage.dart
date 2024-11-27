import 'dart:html' as html;

class TokenStorage {
  static html.Storage _storage = html.window.localStorage;

  /// 사용자 ID를 저장하는 함수
  static Future<void> saveUserId(int userId) async {
    _storage['userId'] = userId.toString();
  }

  /// 액세스 토큰과 리프레시 토큰을 저장하는 함수
  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    _storage['accessToken'] = accessToken;
    _storage['refreshToken'] = refreshToken;
  }

  /// 사용자 ID를 가져오는 함수
  static Future<int?> getUserId() async {
    var userId = _storage['userId'];
    return userId != null ? int.parse(userId) : null;
  }

  /// 액세스 토큰을 가져오는 함수
  static Future<String?> getAccessToken() async {
    return _storage['accessToken'];
  }

  /// 리프레시 토큰을 가져오는 함수
  static Future<String?> getRefreshToken() async {
    return _storage['refreshToken'];
  }

  /// 저장된 토큰을 모두 삭제하는 함수
  static Future<void> clearTokens() async {
    _storage.remove('accessToken');
    _storage.remove('refreshToken');
  }

  /// 사용자 ID를 삭제하는 함수
  static Future<void> clearUserId() async {
    _storage.remove('userId');
  }
}
