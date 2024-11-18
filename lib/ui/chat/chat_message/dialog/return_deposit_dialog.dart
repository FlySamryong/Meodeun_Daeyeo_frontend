import 'package:flutter/material.dart';
import '../../../../service/rent/rent_service.dart';
import '../../../../utils/show_error_dialog.dart';

/// 보증금 반환 다이얼로그
class ReturnDepositDialog extends StatefulWidget {
  final int roomId;
  final int rentId;

  const ReturnDepositDialog({
    required this.roomId,
    required this.rentId,
    Key? key,
  }) : super(key: key);

  @override
  _ReturnDepositDialogState createState() => _ReturnDepositDialogState();
}

class _ReturnDepositDialogState extends State<ReturnDepositDialog> {
  bool _isLoading = false;

  /// 보증금 반환 처리 함수
  Future<void> _submitReturnDeposit(bool isReturn) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await RentService().returnDeposit(
        context: context,
        roomId: widget.roomId,
        rentId: widget.rentId,
        isReturn: isReturn,
      );
      Navigator.of(context).pop(); // 다이얼로그 닫기
    } catch (e) {
      showErrorDialog(context, "$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 20),
            _buildMessage(),
            const SizedBox(height: 20),
            _buildTermsAndConditions(),
            const SizedBox(height: 20),
            _isLoading ? const CircularProgressIndicator() : _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// 다이얼로그 제목 위젯
  Widget _buildTitle() {
    return const Text(
      '보증금 반환 여부 확인',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF079702),
      ),
    );
  }

  /// 안내 메시지 위젯
  Widget _buildMessage() {
    return const Text(
      '보증금을 반환하시겠습니까?',
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  /// 약관 및 조건 위젯
  Widget _buildTermsAndConditions() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약관 및 조건:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '1. 허위 훼손/분실 신고 시 법적 책임을 물을 수 있습니다.',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '2. 손실 사실이 확인되지 않을 경우 보증금을 반환해야 합니다.',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '3. 상호 동의 하에 이루어지지 않은 반환 거부 시 계약 위반으로 간주될 수 있습니다.',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '4. 관련 법규에 따라 손해배상이 청구될 수 있습니다.',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '5. 허위 신고로 인한 피해는 추가 법적 조치를 초래할 수 있습니다.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// 동작 버튼 위젯
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // 버튼 오른쪽 정렬
      children: [
        _buildButton(
          label: '아니요',
          color: Colors.redAccent,
          onPressed: () => _submitReturnDeposit(false),
        ),
        const SizedBox(width: 10),
        _buildButton(
          label: '예',
          color: const Color(0xFF079702),
          onPressed: () => _submitReturnDeposit(true),
        ),
      ],
    );
  }

  /// 공통 버튼 생성 함수
  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white), // 텍스트 색상 하얀색
      ),
    );
  }
}
