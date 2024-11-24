import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../service/chat/service/chat_page_service.dart';
import '../../../service/member/member_service.dart';
import '../../../utils/show_error_dialog.dart';
import '../../../utils/show_success_dialog.dart';
import '../../chat/chat_message/chat_page.dart';

class ActionButtonsWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final SizingInformation sizingInformation;
  final ChatService chatService = ChatService();
  final MemberService memberService = MemberService();

  ActionButtonsWidget({
    required this.data,
    required this.sizingInformation, // SizingInformation 추가
    super.key,
  });

  /// 채팅 버튼 클릭 시 호출되는 함수
  Future<void> _onChatButtonPressed(BuildContext context) async {
    final roomId = await chatService.createChatRoom(
      itemId: data['itemId'],
      ownerId: data['owner']['memberId'],
      context: context,
    );

    if (roomId != null) {
      // 채팅방 생성이 성공하면 ChatPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            roomId: roomId,
            title: data['name'],
            ownerId: data['owner']['memberId'],
            sizingInformation: sizingInformation,
          ),
        ),
      );
    }
  }

  /// 관심 목록 추가 버튼 클릭 시 호출되는 함수
  Future<void> _onFavoriteButtonPressed(BuildContext context) async {
    try {
      await memberService.addToWishList(
        context: context,
        itemId: data['itemId'], // 관심 목록에 추가할 itemId 전달
      );
      showSuccessDialog(context, '관심 목록에 추가되었습니다.');
    } catch (e) {
      debugPrint('관심 목록 추가 실패: $e');
      showErrorDialog(context, '관심 목록 추가에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildChatButton(context), // 채팅 버튼
        _buildFavoriteButton(context), // 관심 목록 버튼
      ],
    );
  }

  /// 채팅 버튼 위젯
  Widget _buildChatButton(BuildContext context) {
    return _buildActionButton(
      icon: Icons.chat,
      label: '채팅하기',
      color: Colors.yellow,
      onPressed: () => _onChatButtonPressed(context), // 채팅 버튼 눌렀을 때 호출
    );
  }

  /// 관심 목록 버튼 위젯
  Widget _buildFavoriteButton(BuildContext context) {
    return _buildActionButton(
      icon: Icons.favorite_border,
      label: '관심 목록 추가하기',
      color: Colors.red,
      onPressed: () => _onFavoriteButtonPressed(context), // 관심 목록 추가 로직 연결
    );
  }

  /// 공통 액션 버튼 위젯
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'BM Dohyeon',
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        side: BorderSide(color: const Color(0xFF079702), width: 2),
      ),
    );
  }
}
