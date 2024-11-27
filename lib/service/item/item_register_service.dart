import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../../utils/show_error_dialog.dart';
import '../../utils/token_storage.dart';
import '../api_client.dart';
import 'package:http/http.dart' as http;

class ItemRegisterService {
  Future<bool> registerItem({
    required BuildContext context,
    required List<Uint8List> imageFiles,
    required Map<String, dynamic> itemDTO,
    required Map<String, dynamic> locationDTO,
  }) async {
    try {
      final uri = Uri.parse('${ApiClient.baseUrl}/item/create'); // URI 생성

      final accessToken = await TokenStorage.getAccessToken(); // 액세스 토큰 가져오기
      if (accessToken == null) {
        showErrorDialog(context, '로그인이 필요합니다.');
        return false;
      }

      // 멀티파트 요청 생성
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = '*/*';

      // JSON 데이터 추가 (Content-Type: application/json 명시)
      request.files.add(
        http.MultipartFile.fromString(
          'itemDTO',
          jsonEncode(itemDTO),
          contentType: MediaType('application', 'json'),
        ),
      );
      request.files.add(
        http.MultipartFile.fromString(
          'locationDTO',
          jsonEncode(locationDTO),
          contentType: MediaType('application', 'json'),
        ),
      );

      // 이미지 파일 추가
      for (var i = 0; i < imageFiles.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
          'imageList',
          imageFiles[i],
          filename: 'image_$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // 요청 전송
      final response = await request.send();

      // 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);
        if (responseData['isSuccess'] == true) {
          return true;
        } else {
          showErrorDialog(
              context, responseData['message'] ?? '알 수 없는 오류가 발생했습니다.');
        }
      } else {
        showErrorDialog(context, '서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog(context, '요청 중 오류가 발생했습니다: $e');
    }

    return false; // 실패
  }
}
