import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/show_error_dialog.dart';
import '../../../../service/rent/rent_service.dart';

/// 대여 종료 날짜 입력 다이얼로그
class DateInputDialog extends StatefulWidget {
  final int roomId;
  final int rentId;

  const DateInputDialog({
    required this.roomId,
    required this.rentId,
    Key? key,
  }) : super(key: key);

  @override
  _DateInputDialogState createState() => _DateInputDialogState();
}

class _DateInputDialogState extends State<DateInputDialog> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: _buildTitle(),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }

  /// 다이얼로그 제목
  Widget _buildTitle() {
    return const Text(
      '대여 종료 날짜 입력',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Color(0xFF079702),
      ),
    );
  }

  /// 다이얼로그 내용
  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputField(
          controller: _dateController,
          labelText: '날짜 입력',
          icon: Icons.calendar_today,
          onTap: _pickDate,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          controller: _timeController,
          labelText: '시간 입력',
          icon: Icons.access_time,
          onTap: _pickTime,
        ),
      ],
    );
  }

  /// 다이얼로그 버튼
  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('취소', style: TextStyle(color: Colors.redAccent)),
      ),
      ElevatedButton(
        onPressed: _submitDate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF079702),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('확인'),
      ),
    ];
  }

  /// 공통 입력 필드 생성
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF079702)),
        border: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
        suffixIcon: Icon(icon, color: const Color(0xFF079702)),
      ),
      onTap: onTap,
    );
  }

  /// OutlineInputBorder 스타일 공통화
  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF079702)),
    );
  }

  /// 날짜 선택
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return _buildPickerTheme(child);
      },
    );

    if (pickedDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  /// 시간 선택
  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return _buildPickerTheme(child);
      },
    );

    if (pickedTime != null) {
      _timeController.text =
          '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
    }
  }

  /// 테마 적용된 DatePicker/TimePicker 빌더
  Widget _buildPickerTheme(Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF079702),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF079702),
          onSurface: Colors.black,
        ),
        dialogBackgroundColor: Colors.white,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF079702),
          ),
        ),
      ),
      child: child!,
    );
  }

  /// 입력된 날짜와 시간 제출
  void _submitDate() async {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
      showErrorDialog(context, '날짜와 시간을 모두 입력해주세요.');
      return;
    }

    try {
      final selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(
        '${_dateController.text} ${_timeController.text}',
      );

      final formattedDate =
          DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

      await RentService().acceptRent(
        context: context,
        roomId: widget.roomId,
        rentId: widget.rentId,
        endDate: formattedDate,
      );
      Navigator.pop(context); // 다이얼로그 닫기
    } catch (e) {
      showErrorDialog(context, '오류 발생: $e');
    }
  }
}
