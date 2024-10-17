class LoginResponse {
  final int id;
  final String name;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.id,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
  });

  // 서버 응답 JSON을 DTO로 변환하는 팩토리 메서드
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      name: json['name'],
      accessToken: json['token']['accessToken'],
      refreshToken: json['token']['refreshToken'],
    );
  }
}
