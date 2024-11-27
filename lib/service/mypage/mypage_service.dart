import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../utils/show_error_dialog.dart';
import '../api_client.dart';

class MyPageService {
  final ApiClient _apiClient = ApiClient();

  // 에러 메시지 상수 정의
  static const String _unknownErrorMessage = '알 수 없는 오류가 발생했습니다.';
  static const String _fetchErrorMessage = '마이페이지 데이터를 가져오는 중 오류가 발생했습니다.';

  /// 마이페이지 데이터를 가져오는 메서드
  Future<MyPageData> fetchMyPageData({
    required BuildContext context,
  }) async {
    try {
      // API 요청
      final response = await _apiClient.get(
        endpoint: 'member/myPage',
        context: context,
      );

      // 상태 코드에 따라 응답 처리
      if (response.statusCode == 200) {
        final result = _parseResponse(response.bodyBytes);
        if (result['isSuccess'] == true) {
          return MyPageData.fromJson(result['data']);
        } else {
          return _showErrorAndThrow(
              context, result['message'] ?? _unknownErrorMessage);
        }
      } else {
        return _showErrorAndThrow(context, _fetchErrorMessage);
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      return _showErrorAndThrow(context, '$_fetchErrorMessage: $e');
    }
  }

  /// 응답 데이터를 JSON 형태로 파싱하여 반환하는 헬퍼 메서드
  Map<String, dynamic> _parseResponse(Uint8List bodyBytes) {
    return jsonDecode(utf8.decode(bodyBytes));
  }

  /// 에러 메시지를 다이얼로그로 표시하고 예외를 발생시키는 헬퍼 메서드
  MyPageData _showErrorAndThrow(BuildContext context, String message) {
    showErrorDialog(context, message);
    throw Exception(message); // 예외 발생
  }
}

/// MyPageData 모델
class MyPageData {
  final String nickName;
  final String email;
  final String profileImage;
  final double mannerRate;
  final Location location;
  final List<Account> accountList;

  MyPageData({
    required this.nickName,
    required this.email,
    required this.profileImage,
    required this.mannerRate,
    required this.location,
    required this.accountList,
  });

  factory MyPageData.fromJson(Map<String, dynamic> json) {
    return MyPageData(
      nickName: json['nickName'] ?? '닉네임 없음', // null 처리
      email: json['email'] ?? '이메일 없음',
      profileImage: json['profileImage'] ?? '',
      mannerRate: (json['mannerRate'] as num?)?.toDouble() ?? 0.0,
      location: Location.fromJson(json['location'] ?? {}),
      accountList: (json['accountList'] as List<dynamic>?)
          ?.map((item) => Account.fromJson(item))
          .toList() ??
          [],
    );
  }
}

/// Location 모델
class Location {
  final String city;
  final String district;
  final String neighborhood;

  Location({
    required this.city,
    required this.district,
    required this.neighborhood,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'] ?? '도시 없음',
      district: json['district'] ?? '구 없음',
      neighborhood: json['neighborhood'] ?? '동 없음',
    );
  }
}

/// Account 모델
class Account {
  final String accountNum;
  final String finTechAccountNum;

  Account({
    required this.accountNum,
    required this.finTechAccountNum,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountNum: json['accountNum'] ?? '계좌번호 없음',
      finTechAccountNum: json['finTechAccountNum'] ?? '핀테크 번호 없음',
    );
  }
}