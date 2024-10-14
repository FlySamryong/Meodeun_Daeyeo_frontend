import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(const ChatPage());
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ResponsiveBuilder(
        builder: (context, sizingInfo) {
          return Scaffold(
            body: Center(
              child: Container(
                width:
                    360 * (sizingInfo.screenSize.width / 360).clamp(0.8, 1.2),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildChatAppBar(),
                    // 채팅 페이지 상단의 사용자 정의 AppBar
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _buildChatMessageList(), // 채팅 메시지 목록
                      ),
                    ),
                    _buildMessageInputField(context),
                    // 메시지 입력 필드
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 채팅 페이지 상단 AppBar
  Widget _buildChatAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.home, Color(0xFF079702).withOpacity(0.95), () {
            // 홈으로 이동
          }),
          Text(
            '상대방 닉네임',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'BM Dohyeon',
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              _buildIconButton(
                  Icons.thermostat, Colors.yellow.withOpacity(0.95), () {
                // 매너 온도 기능
              }),
              _buildIconButton(Icons.report, Colors.red.withOpacity(0.95), () {
                // 신고 기능
              }),
            ],
          ),
        ],
      ),
    );
  }

  // 사용자 정의 아이콘 버튼 위젯
  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }

  // 메시지 입력 필드, "+" 버튼으로 송금하기 또는 반납하기 기능
  Widget _buildMessageInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // 송금하기 및 반납하기를 위한 PopupMenuButton
          PopupMenuButton<String>(
            icon: const Icon(Icons.add, color: Color(0xFF079702)),
            color: Colors.white,
            onSelected: (String result) {
              if (result == '송금하기') {
                // 송금하기 로직
              } else if (result == '반납하기') {
                // 반납하기 로직
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '송금하기',
                child: _buildPopupMenuItem('송금하기', Color(0xFF079702)),
              ),
              PopupMenuItem<String>(
                value: '반납하기',
                child: _buildPopupMenuItem('반납하기', Colors.orange),
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF079702)),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  // 메시지 전송 메서드
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear(); // 메시지 전송 후 입력 필드 비우기
      });
    }
  }

  // 채팅 메시지 목록
  Widget _buildChatMessageList() {
    return ListView.builder(
      itemCount: _messages.length, // 실제 메시지 수
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: index % 2 == 0
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              // 세로 및 가로 여백 추가
              padding: const EdgeInsets.all(12),
              // 박스 안의 간격을 더 넓게
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Colors.grey.shade300
                    : const Color(0xFF079702).withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft:
                      index % 2 == 0 ? Radius.zero : Radius.circular(16),
                  bottomRight:
                      index % 2 == 0 ? Radius.circular(16) : Radius.zero,
                ), // 대화 상자처럼 보이도록 둥글게
              ),
              child: Text(
                _messages[index], // 실제 메시지 표시
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'BM Dohyeon',
                  color: index % 2 == 0
                      ? Color(0xFF079702)
                      : Colors.white, // 회색 배경에서는 녹색 텍스트
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '오후 7:24', // 고정된 메시지 시간
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'BM Dohyeon',
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 팝업 메뉴 항목 스타일
  Widget _buildPopupMenuItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontFamily: 'BM Dohyeon',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
