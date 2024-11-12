import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../service/chat/service/chat_page_service.dart';
import '../chat_message/chat_page.dart';
import 'chat_card.dart';

/// 채팅 목록 위젯
class ChatList extends StatefulWidget {
  final ScrollController scrollController;
  final SizingInformation sizingInformation;

  const ChatList({
    required this.scrollController,
    required this.sizingInformation,
    super.key,
  });

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Future<List<Map<String, dynamic>>?> chatList;
  final ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    chatList = chatService.fetchChatRooms(context: context); // 실제 데이터 요청
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildChatListView(snapshot.data!);
        } else {
          return const Center(child: Text('No chat rooms available'));
        }
      },
    );
  }

  /// 에러 발생 시 표시할 위젯
  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  /// 채팅 목록을 표시하는 ListView 빌더
  Widget _buildChatListView(List<Map<String, dynamic>> chats) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return _buildChatItem(chats[index], index);
      },
    );
  }

  /// 개별 채팅 항목을 구성하는 위젯
  Widget _buildChatItem(Map<String, dynamic> chat, int index) {
    return GestureDetector(
      onTap: () => _navigateToChatPage(chat['chatRoomId'], chat['itemName']),
      child: ChatCard(chat: chat),
    );
  }

  /// 채팅 페이지로 이동하는 함수
  void _navigateToChatPage(int roomId, String chatPartnerName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          sizingInformation: widget.sizingInformation,
          roomId: roomId,
          title: chatPartnerName,
        ),
      ),
    );
  }
}
