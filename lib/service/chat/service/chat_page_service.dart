import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../../utils/show_error_dialog.dart';
import '../../api_client.dart';

class ChatService {
  final ApiClient apiClient = ApiClient();

  // 에러 메시지 상수 정의
  static const String _createChatRoomErrorMessage = '채팅방 생성 실패';
  static const String _fetchMessagesErrorMessage = '메시지를 불러오는 중 오류가 발생했습니다.';
  static const String _fetchChatRoomsErrorMessage = '채팅 목록을 불러오는 중 오류가 발생했습니다.';
  static const String _networkErrorMessage = '네트워크 오류가 발생했습니다.';

  ChatService();

  /// 채팅방 생성 메서드
  /// 성공 시 roomId를 반환, 실패 시 null을 반환합니다.
  Future<int?> createChatRoom({
    required int itemId,
    required int ownerId,
    required BuildContext context,
  }) async {
    try {
      // 채팅방 생성 API 요청을 보냅니다.
      final response = await apiClient.post(
        endpoint: 'chat/room/create',
        body: {
          'itemId': itemId,
          'ownerId': ownerId,
        },
        context: context,
      );

      // JSON 응답을 파싱하여 결과를 처리합니다.
      final responseData = _parseResponse(response.bodyBytes);
      if (_isRequestSuccessful(response, responseData)) {
        return responseData['data']; // 채팅방 생성 성공 시 roomId 반환
      } else {
        // 실패 시 에러 메시지를 다이얼로그로 표시
        _showErrorMessage(
            context, responseData['message'] ?? _createChatRoomErrorMessage);
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 발생 시 에러 메시지 표시
      _showErrorMessage(context, _networkErrorMessage);
    }
    return null;
  }

  /// 채팅방 메시지 조회 메서드
  /// 성공 시 메시지 데이터를 반환, 실패 시 null을 반환합니다.
  Future<Map<String, dynamic>?> fetchChatMessages({
    required int roomId,
    required BuildContext context,
  }) async {
    try {
      // 메시지 조회 API 요청을 보냅니다.
      final response = await apiClient.get(
        endpoint: 'chat/room/messageList?roomId=$roomId',
        context: context,
      );

      // 응답 상태와 데이터를 확인하여 처리
      final responseData = _parseResponse(response.bodyBytes);
      if (_isRequestSuccessful(response, responseData)) {
        return responseData['data']; // 메시지 조회 성공 시 데이터 반환
      } else {
        print('Failed to fetch messages: ${responseData['message']}');
      }
    } catch (e) {
      // 네트워크 오류 발생 시 에러 메시지 표시
      _showErrorMessage(context, _fetchMessagesErrorMessage);
    }
    return null;
  }

  /// 채팅방 목록 조회 메서드
  Future<List<Map<String, dynamic>>?> fetchChatRooms({
    required BuildContext context,
  }) async {
    try {
      final response = await apiClient.get(
        endpoint: 'chat/room/list',
        context: context,
      );

      final responseData = _parseResponse(response.bodyBytes);
      if (_isRequestSuccessful(response, responseData)) {
        return List<Map<String, dynamic>>.from(
            responseData['data']['chatRoomList']);
      } else {
        _showErrorMessage(
          context,
          responseData['message'] ?? _fetchChatRoomsErrorMessage,
        );
      }
    } catch (e) {
      _showErrorMessage(context, _networkErrorMessage);
    }
    return null;
  }

  /// 응답 데이터를 JSON 형태로 파싱하여 반환합니다.
  Map<String, dynamic> _parseResponse(Uint8List bodyBytes) {
    return jsonDecode(utf8.decode(bodyBytes));
  }

  /// 요청이 성공했는지 확인하는 헬퍼 메서드
  bool _isRequestSuccessful(http.Response response, Map<String, dynamic> data) {
    return response.statusCode == 200 && data['isSuccess'] == true;
  }

  /// 에러 메시지를 다이얼로그로 표시하는 헬퍼 메서드
  void _showErrorMessage(BuildContext context, String message) {
    showErrorDialog(context, message);
  }

  /// 매너 온도 업데이트 메서드
  Future<bool> updateMannerRate({
    required int roomId,
    required int mannerRate,
    required BuildContext context,
  }) async {
    try {
      final response = await apiClient.get(
        endpoint:
            'chat/room/update/mannerRate?roomId=$roomId&mannerRate=$mannerRate',
        context: context,
      );

      final responseData = _parseResponse(response.bodyBytes);
      if (_isRequestSuccessful(response, responseData)) {
        return true;
      } else {
        _showErrorMessage(
          context,
          responseData['message'] ?? '매너 온도 업데이트에 실패했습니다.',
        );
      }
    } catch (e) {
      _showErrorMessage(context, _networkErrorMessage);
    }
    return false;
  }
}
