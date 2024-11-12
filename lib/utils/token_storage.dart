import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  /// 사용자 ID를 저장하는 함수
  static Future<void> saveUserId(int userId) async {
    await _storage.write(key: 'userId', value: userId.toString());
  }

  /// 액세스 토큰과 리프레시 토큰을 저장하는 함수
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  /// 사용자 ID를 가져오는 함수
  static Future<int?> getUserId() async {
    var userId = await _storage.read(key: 'userId');
    return userId != null ? int.parse(userId) : null;
  }

  /// 액세스 토큰을 가져오는 함수
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  /// 리프레시 토큰을 가져오는 함수
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  /// 저장된 토큰을 모두 삭제하는 함수
  static Future<void> clearTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }
}
