import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../../../utils/show_error_dialog.dart';
import 'auth_service.dart';
import '../dto/login_response_dto.dart';

class KakaoLoginService {
  final AuthService _authService = AuthService();

  // 에러 메시지를 상수로 정의하여 코드 가독성 및 유지보수성을 향상시킵니다.
  static const String _kakaoLoginErrorMessage = "Kakao 로그인 오류";

  /// 카카오 계정을 사용하여 로그인 처리
  /// 성공 시 AuthService를 통해 백엔드에 로그인 요청을 전달합니다.
  Future<LoginResponse?> loginWithKakao(BuildContext context) async {
    try {
      // 카카오 계정 로그인 수행
      final token = await _loginWithKakaoAccount();
      if (token != null) {
        print('Kakao accessToken: ${token.accessToken}');
        // 백엔드에 로그인 요청을 전달하고 응답을 반환합니다.
        return await _authService.loginWithAccessToken(
            token.accessToken, context);
      }
    } catch (e) {
      // 로그인 오류 발생 시 에러 메시지를 다이얼로그로 표시합니다.
      _showKakaoLoginError(context, e);
    }
    return null;
  }

  /// 카카오 계정 로그인 요청을 수행하고, OAuthToken을 반환합니다.
  /// 오류 발생 시 null을 반환합니다.
  Future<OAuthToken?> _loginWithKakaoAccount() async {
    try {
      return await UserApi.instance.loginWithKakaoAccount();
    } catch (e) {
      // 로그인을 실패한 경우 에러를 기록하고 null 반환
      print('카카오 로그인 실패: ${e.toString()}');
      return null;
    }
  }

  /// 카카오 로그인 에러 발생 시 다이얼로그를 통해 에러 메시지를 표시합니다.
  void _showKakaoLoginError(BuildContext context, Object error) {
    showErrorDialog(context, "$_kakaoLoginErrorMessage: ${error.toString()}");
  }
}
