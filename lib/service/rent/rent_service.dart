import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_client.dart';

/// 대여 서비스
class RentService {
  final ApiClient _apiClient = ApiClient();

  /// 공통 GET 요청 처리
  Future<Map<String, dynamic>> _sendGetRequest({
    required BuildContext context,
    required String endpoint,
    String? defaultErrorMessage,
  }) async {
    try {
      final response = await _apiClient.get(
        endpoint: endpoint,
        context: context,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        final errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorResponse['message'] ?? defaultErrorMessage;
        throw Exception(errorMessage ?? '요청 처리 중 오류 발생');
      }
    } catch (e) {
      debugPrint('API 요청 오류: $e');
      throw Exception(e.toString());
    }
  }

  /// 대여 생성 API 호출
  Future<int> createRent({
    required BuildContext context,
    required int roomId,
    required String fee,
  }) async {
    final endpoint = 'rent/create?roomId=$roomId&fee=$fee';
    final response = await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: '대여 생성 실패',
    );

    return response['data']; // 대여 ID 반환
  }

  /// 대여 수락 API 호출
  Future<void> acceptRent({
    required BuildContext context,
    required int roomId,
    required int rentId,
    required String endDate,
  }) async {
    final endpoint = 'rent/accept?roomId=$roomId&rentId=$rentId&endDate=$endDate';
    await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: '대여 수락 실패',
    );
  }

  /// 최종 대여 API 호출
  Future<void> finalizeRent({
    required BuildContext context,
    required int roomId,
    required int rentId,
  }) async {
    final endpoint = 'rent/accept-process?roomId=$roomId&rentId=$rentId';
    await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: '최종 대여 실패',
    );
  }

  /// OTP 생성 API 호출
  Future<String> generateOtp({
    required BuildContext context,
    required int roomId,
    required int rentId,
  }) async {
    final endpoint = 'rent/generate-otp?roomId=$roomId&rentId=$rentId';
    final response = await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: 'OTP 생성 실패',
    );

    return response['data']; // 생성된 OTP 반환
  }

  /// OTP 검증 API 호출
  Future<void> verifyOtp({
    required BuildContext context,
    required int roomId,
    required int rentId,
    required String otp,
  }) async {
    final endpoint = 'rent/verify-otp?roomId=$roomId&rentId=$rentId&otp=$otp';
    await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: 'OTP 검증 실패',
    );
  }

  /// 보증금 반환 API 호출
  Future<void> returnDeposit({
    required BuildContext context,
    required int roomId,
    required int rentId,
    required bool isReturn,
  }) async {
    final endpoint =
        'rent/return-deposit?roomId=$roomId&rentId=$rentId&isReturn=$isReturn';
    await _sendGetRequest(
      context: context,
      endpoint: endpoint,
      defaultErrorMessage: '보증금 반환 실패',
    );
  }
}
