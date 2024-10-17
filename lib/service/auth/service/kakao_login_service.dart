import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../dto/login_response_dto.dart';

class KakaoLoginService {
  Future<LoginResponse?> loginWithKakao(BuildContext context) async {
    OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    print('accessToken: ${token.accessToken}');
  }
}
