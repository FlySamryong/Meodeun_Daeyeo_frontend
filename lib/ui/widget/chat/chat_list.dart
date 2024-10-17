import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../chat/chat_page.dart';
import 'chat_card.dart';

// 채팅 목록 위젯
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
  late Future<List<Map<String, dynamic>>> chatList;

  @override
  void initState() {
    super.initState();
    chatList = _fetchChatList();
  }

  // 임시 데이터
  Future<List<Map<String, dynamic>>> _fetchChatList() async {
  int length = 10;
  return List.generate(length, (index) {
    int reverseIndex = length - index - 1;
    return {
      'chatPartner': '채팅상대 $reverseIndex',
      'lastMessage': '마지막 메시지 내용 $reverseIndex',
      'lastMessageTime': '오후 3:2$reverseIndex',
    };
  });
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final chats = snapshot.data!;
          return ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        sizingInformation: widget.sizingInformation,
                      ),
                    ),
                  );
                },
                child: ChatCard(chat: chats[index]),
              );
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
