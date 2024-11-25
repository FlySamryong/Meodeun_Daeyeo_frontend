import 'package:flutter/material.dart';

class MannerRateDialog extends StatelessWidget {
  final Function(int) onRateSelected;

  MannerRateDialog({required this.onRateSelected, Key? key}) : super(key: key);

  // 점수에 따른 설명 리스트
  final List<String> mannerDescriptions = [
    '매너가 너무 없어요', // 1점
    '매너가 살짝 부족했어요', // 2점
    '보통이에요', // 3점
    '매너가 좋았어요', // 4점
    '최고의 매너였어요', // 5점
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      title: Text(
        '채팅 상대방의 매너 점수를 선택해주세요',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF079702),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => ListTile(
            title: Row(
              children: [
                Row(
                  children: List.generate(
                    index + 1,
                    (_) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  mannerDescriptions[index],
                  textAlign: TextAlign.right, // 오른쪽 정렬
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              onRateSelected(index + 1);
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF079702),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('취소'),
        ),
      ],
    );
  }
}
