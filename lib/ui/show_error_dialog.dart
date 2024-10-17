import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // 흰색 배경
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 둥근 모서리 처리
        ),
        title: Text(
          '오류 발생',
          style: TextStyle(
            color: Colors.black, // 검정색 텍스트
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'BM Dohyeon', // 배민 폰트 사용
          ),
        ),
        content: Text(
          errorMessage,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8), // 검정색 약간 투명한 텍스트
            fontSize: 16,
            fontFamily: 'BM Dohyeon', // 배민 폰트 사용
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: Text('확인'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // 흰색 텍스트
              backgroundColor: Color(0xFF079702).withOpacity(0.95), // 버튼 배경색
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 버튼 둥근 모서리
              ),
            ),
          ),
        ],
      );
    },
  );
}
