import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../../service/chat/service/chat_page_service.dart';
import '../../../utils/token_storage.dart';

import 'chat_message_list.dart';
import 'message_input_field.dart';
import 'app_bar/appbar.dart';

/// 채팅 메시지 타입
enum ChatType {
  TEXT, // 일반 텍스트 메시지
  IMAGE, // 이미지 메시지
  RENT_REQ, // 물품 대여 요청
  RENT_ACCEPT, // 물품 대여 수락
  RENT_AGREE, // 물품 대여 동의
  DEPOSIT_REQ, // 보증금 반납 요청
  DEPOSIT_RES, // 보증금 반납 응답
  OVERDUE, // 연체
  CANCEL, // 취소
}

/// 채팅 메시지 클래스
class ChatMessage {
  final String content;
  final ChatType type;
  final bool isSender;

  ChatMessage({
    required this.content,
    required this.type,
    required this.isSender,
  });

  // JSON에서 ChatMessage 객체로 변환
  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    return ChatMessage(
      content: _decodeMessage(json['message']),
      type: ChatType.values.firstWhere(
        (e) => e.toString() == 'ChatType.${json['type']}',
        orElse: () => ChatType.TEXT,
      ),
      isSender: json['senderId'] == currentUserId,
    );
  }

  // UTF-8로 메시지를 디코딩
  static String _decodeMessage(String message) {
    try {
      return utf8.decode(message.codeUnits);
    } catch (e) {
      return message;
    }
  }
}

/// 채팅 페이지
class ChatPage extends StatefulWidget {
  final SizingInformation sizingInformation;
  final int roomId;
  final String title;

  const ChatPage({
    required this.sizingInformation,
    required this.roomId,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  StompClient? _stompClient;
  int? _currentUserId;
  String? _accessToken;
  final ChatService chatService = ChatService();
  bool isRenter = false;

  final Map<ChatType, String> _chatTypeMessages = {
    ChatType.RENT_REQ: '대여 요청이 수신되었습니다. 12시간 내로 확인해주세요.',
    ChatType.RENT_ACCEPT: '대여 요청이 수락되었습니다. 대여 절차를 진행하세요.',
    ChatType.RENT_AGREE: '대여가 최종 확정되었습니다. 일정에 따라 이용해주세요.',
    ChatType.DEPOSIT_REQ: '반납까지 2시간 남았습니다. 반납 준비 부탁드립니다.',
    ChatType.OVERDUE: '반납 기한이 초과되어 연체료가 부과됩니다.',
  };

  static const double baseWidth = 360.0;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadUserData();
    await _fetchChatMessages();
  }

  Future<void> _loadUserData() async {
    _currentUserId = await TokenStorage.getUserId();
    _accessToken = await TokenStorage.getAccessToken();
    if (_accessToken != null) {
      _connectStomp();
    }
  }

  Future<void> _fetchChatMessages() async {
    final messages = await chatService.fetchChatMessages(
      roomId: widget.roomId,
      context: context,
    );
    if (messages != null && _currentUserId != null) {
      setState(() {
        _messages.addAll((messages['chatMessageList'] as List)
            .map((msg) => ChatMessage.fromJson(msg, _currentUserId!))
            .toList());
      });
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _stompClient?.deactivate();
    _scrollController.dispose();
    _messageController.dispose();
  }

  void _connectStomp() {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://54.180.28.151:8080/ws/stomp',
        onConnect: _onStompConnected,
        onStompError: (frame) => print('STOMP error: ${frame.body}'),
        onDisconnect: (frame) => print('Disconnected from STOMP'),
        onWebSocketError: (error) => print('WebSocket error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $_accessToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $_accessToken'},
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
      ),
    );
    _stompClient?.activate();
  }

  void _onStompConnected(StompFrame frame) {
    _stompClient?.subscribe(
      destination: '/topic/chat/room/${widget.roomId}',
      callback: (frame) => _receiveMessage(frame.body),
    );
  }

  void _receiveMessage(String? body) {
    if (body != null) {
      final messageData = jsonDecode(body);
      setState(() {
        _messages.insert(0, ChatMessage.fromJson(messageData, _currentUserId!));
      });
      _scrollToBottom();
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _currentUserId != null) {
      final message = {
        'chatRoomId': widget.roomId,
        'senderId': _currentUserId,
        'message': _messageController.text,
        'type': 'TEXT',
      };
      _stompClient?.send(
        destination: '/app/message',
        body: jsonEncode(message),
      );
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendSpecificMessage(ChatType type) {
    final isSender = _determineSender(type);
    final content = _chatTypeMessages[type] ?? '알 수 없는 메시지 타입입니다.';
    _addMessage(content: content, type: type, isSender: isSender);
  }

  void _addMessage({
    required String content,
    required ChatType type,
    required bool isSender,
  }) {
    setState(() {
      _messages.insert(
          0, ChatMessage(content: content, type: type, isSender: isSender));
    });
    _scrollToBottom();
  }

  bool _determineSender(ChatType type) {
    return (type == ChatType.RENT_REQ || type == ChatType.RENT_AGREE)
        ? isRenter
        : !isRenter;
  }

  IconData _iconForType(ChatType type) {
    switch (type) {
      case ChatType.RENT_REQ:
        return Icons.request_page;
      case ChatType.RENT_ACCEPT:
        return Icons.check;
      case ChatType.RENT_AGREE:
        return Icons.assignment_turned_in;
      case ChatType.DEPOSIT_REQ:
        return Icons.timer;
      case ChatType.OVERDUE:
        return Icons.warning;
      default:
        return Icons.message;
    }
  }

  Color _colorForType(ChatType type) {
    switch (type) {
      case ChatType.RENT_REQ:
        return Colors.orange;
      case ChatType.RENT_ACCEPT:
        return Colors.green;
      case ChatType.RENT_AGREE:
        return Colors.blue;
      case ChatType.DEPOSIT_REQ:
        return Colors.redAccent;
      case ChatType.OVERDUE:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Widget _buildChatTypeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ChatType.values
          .where((type) => type != ChatType.TEXT)
          .map((type) => IconButton(
                icon: Icon(_iconForType(type), color: _colorForType(type)),
                onPressed: () => _sendSpecificMessage(type),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (widget.sizingInformation.screenSize.width / baseWidth).clamp(0.8, 1.2);
    return Scaffold(
      body: Center(
        child: Container(
          width: baseWidth * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ChatAppBar(title: widget.title),
              const SizedBox(height: 10),
              Expanded(
                child: ChatMessageList(
                  messages: _messages,
                  scrollController: _scrollController,
                ),
              ),
              MessageInputField(
                messageController: _messageController,
                onSendMessage: _sendMessage,
                isSender: true,
                isRenter: false,
              ),
              _buildChatTypeButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
