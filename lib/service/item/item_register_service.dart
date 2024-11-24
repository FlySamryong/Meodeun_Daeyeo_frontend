import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ItemRegisterService {
  final String baseUrl;

  ItemRegisterService({required this.baseUrl});

  Future<bool> registerItem({
    required String name,
    required String description,
    required int period,
    required int fee,
    required int deposit,
    required String location,
    required List<String> categories,
    required List<File> images,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/create');
      final request = http.MultipartRequest('POST', uri);

      // Form 데이터 추가
      request.fields['itemDTO'] = jsonEncode({
        'name': name,
        'description': description,
        'period': period,
        'fee': fee,
        'deposit': deposit,
        'location': location,
        'categoryList': categories.map((category) => {'name': category}).toList(),
      });

      // 이미지 파일 추가
      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'imageList',
          image.path,
        ));
      }

      final response = await request.send();

      // 응답 처리
      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        print('Error: ${response.statusCode}');
        return false; // 실패
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}