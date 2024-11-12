import 'package:intl/intl.dart';

class DateTimeFormatter {
  /// 서버에서 받은 날짜 문자열을 한국 시간대로 변환하고
  /// "yyyy년 MM월 dd일 HH시 mm분" 형식으로 포맷합니다.
  static String formatToKoreanDateTime(String dateTimeString) {

    // 서버에서 받은 DateTime 문자열을 DateTime 객체로 변환
    DateTime parsedDateTime = DateTime.parse(dateTimeString);


    // 한국 시간대로 변환
    DateTime koreaTime = parsedDateTime.toLocal();


    // 한국어 형식으로 포맷 (예: 2024년 11월 11일 15시 22분)
    return DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(koreaTime);
  }
}
