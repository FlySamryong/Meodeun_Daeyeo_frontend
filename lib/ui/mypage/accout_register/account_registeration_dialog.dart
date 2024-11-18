import 'package:flutter/material.dart';
import '../../../service/account/account_service.dart';
import '../../../utils/show_error_dialog.dart';

/// 계좌 등록 다이얼로그
class AccountRegistrationDialog extends StatefulWidget {
  final BuildContext parentContext;

  const AccountRegistrationDialog({
    Key? key,
    required this.parentContext,
  }) : super(key: key);

  @override
  _AccountRegistrationDialogState createState() =>
      _AccountRegistrationDialogState();
}

class _AccountRegistrationDialogState extends State<AccountRegistrationDialog> {
  final TextEditingController accountController = TextEditingController();
  String selectedBank = '농협'; // 기본 선택된 은행
  final Color primaryColor = const Color(0xFF079702).withOpacity(0.95); // 초록색

  /// 공통 InputDecoration 스타일 함수
  InputDecoration _buildInputDecoration({
    required String hintText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: primaryColor),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }

  /// 공통 버튼 스타일링 함수
  ButtonStyle _buildButtonStyle({required Color backgroundColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      // 다이얼로그 배경색
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      title: const Text(
        "계좌 등록",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400, // 다이얼로그 가로 크기
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용 크기에 맞게 다이얼로그 크기 조정
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "등록할 계좌번호와 은행을 선택해주세요.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            // 은행 선택 드롭다운
            DropdownButtonFormField<String>(
              value: selectedBank,
              items: const [
                DropdownMenuItem(value: '농협', child: Text('농협')),
                // 추가 은행 항목을 여기에 추가 가능
              ],
              onChanged: (value) {
                setState(() {
                  selectedBank = value!;
                });
              },
              decoration:
                  _buildInputDecoration(hintText: '', labelText: '은행 선택'),
              dropdownColor: Colors.white,
              // 드롭다운 배경색
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: primaryColor, // 드롭다운 아이콘 색상
            ),
            const SizedBox(height: 10),
            // 계좌번호 입력 필드
            TextField(
              controller: accountController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration(hintText: "계좌번호 입력"),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 취소 버튼
            SizedBox(
              width: 100, // 버튼 가로 크기
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                ),
                child: const Text("취소"),
              ),
            ),
            const SizedBox(width: 10), // 버튼 간격
            // 확인 버튼
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: _handleConfirmButtonPressed,
                style: _buildButtonStyle(backgroundColor: primaryColor),
                child: const Text("확인"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 확인 버튼 클릭 시 실행될 함수
  Future<void> _handleConfirmButtonPressed() async {
    final accountNumber = accountController.text.trim();

    if (accountNumber.isEmpty) {
      showErrorDialog(context, "계좌번호를 입력해주세요!");
      return;
    }

    final accountService = AccountService();
    try {
      final success = await accountService.registerAccount(
        context: widget.parentContext,
        accountNumber: accountNumber,
      );

      if (success) {
        Navigator.pop(context); // 다이얼로그 닫기
      }
    } catch (e) {
      if (e is Exception) {
        showErrorDialog(context, e.toString().replaceAll("Exception: ", ""));
      } else {
        showErrorDialog(context, "알 수 없는 오류가 발생했습니다.");
      }
    }
  }
}
