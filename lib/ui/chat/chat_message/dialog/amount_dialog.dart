import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../service/rent/rent_service.dart';
import '../../../../utils/show_error_dialog.dart';

/// 대여료 송금 다이얼로그
class AmountDialog extends StatelessWidget {
  final TextEditingController controller;
  final int roomId;
  final Function(int) onRentCreated;

  const AmountDialog({
    required this.controller,
    required this.roomId,
    required this.onRentCreated,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFF079702), width: 2),
      ),
      child: SizedBox(
        width: 300,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 8),
              _buildSubtitle(),
              const SizedBox(height: 20),
              _buildAmountInputField(),
              const SizedBox(height: 20),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 제목 위젯
  Widget _buildTitle() {
    return Center(
      child: Text(
        '대여료 송금하기',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF079702),
        ),
      ),
    );
  }

  /// 설명 위젯
  Widget _buildSubtitle() {
    return Center(
      child: Text(
        '설정해주신 금액과 함께 보증금이 자동 출금됩니다.\n'
        '수신자가 12시간 내에 수신하지 않을 경우 자동 환급됩니다.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  /// 금액 입력 필드
  Widget _buildAmountInputField() {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '금액을 입력하세요',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF079702), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF079702), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 대여 요청 버튼
  Widget _buildSubmitButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () => _handleCreateRent(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF079702),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            '대여 요청',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  /// 대여 요청 처리 함수
  Future<void> _handleCreateRent(BuildContext context) async {
    final fee = controller.text.trim();

    if (fee.isEmpty || int.tryParse(fee) == null) {
      showErrorDialog(context, '유효한 금액을 입력하세요.');
      return;
    }

    try {
      final rentService = RentService();
      final rentId = await rentService.createRent(
        context: context,
        roomId: roomId,
        fee: fee,
      );

      onRentCreated(rentId); // rentId 전달 콜백 실행
      Navigator.pop(context);
    } catch (e) {
      showErrorDialog(context, e.toString().replaceAll('Exception: ', ''));
    }
  }
}
