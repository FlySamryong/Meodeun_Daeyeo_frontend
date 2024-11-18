import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../../service/chat/service/chat_page_service.dart';
import '../../../utils/token_storage.dart';
import '../../../utils/rent_id_storage.dart';
import 'chat_message.dart';
import 'chat_message_list.dart';
import 'message_input_field.dart';
import 'app_bar/appbar.dart';

enum ChatType {
  TEXT,
  IMAGE,
  RENT_REQ,
  RENT_ACCEPT,
  RENT_AGREE,
  DEPOSIT_REQ,
  DEPOSIT_RES,
  OVERDUE,
  CANCEL,
  NOTICE,
}

/// 채팅 페이지
class ChatPage extends StatefulWidget {
  final SizingInformation sizingInformation;
  final int roomId;
  final int ownerId;
  final String title;

  const ChatPage({
    required this.sizingInformation,
    required this.roomId,
    required this.ownerId,
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
  int? _rentId;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  /// 초기화: 사용자 데이터 및 메시지 로드, Stomp 연결
  Future<void> _initializeChat() async {
    await _loadUserData();
    await _fetchChatMessages();
    await _loadRentId();
  }

  /// 사용자 데이터 로드
  Future<void> _loadUserData() async {
    _currentUserId = await TokenStorage.getUserId();
    _accessToken = await TokenStorage.getAccessToken();
    if (_accessToken != null) {
      _connectStomp();
    }
  }

  /// Rent ID 로드 및 상태 업데이트
  Future<void> _loadRentId() async {
    final rentId = await RentIdStorage.loadRentId(widget.roomId);
    setState(() {
      _rentId = rentId;
    });
  }

  /// Rent ID 저장 및 상태 업데이트
  Future<void> _updateRentId(int rentId) async {
    setState(() {
      _rentId = rentId;
    });
    await RentIdStorage.saveRentId(widget.roomId, rentId);
  }

  /// 채팅 메시지 로드
  Future<void> _fetchChatMessages() async {
    final messages = await _chatService.fetchChatMessages(
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
    _stompClient?.deactivate();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Stomp 연결 설정
  void _connectStomp() {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://54.180.28.151:8080/ws/stomp',
        onConnect: _onStompConnected,
        onStompError: (frame) => debugPrint('STOMP error: ${frame.body}'),
        onDisconnect: (frame) => debugPrint('Disconnected from STOMP'),
        onWebSocketError: (error) => debugPrint('WebSocket error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $_accessToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $_accessToken'},
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
      ),
    );
    _stompClient?.activate();
  }

  /// Stomp 연결 성공 시 구독
  void _onStompConnected(StompFrame frame) {
    _stompClient?.subscribe(
      destination: '/topic/chat/room/${widget.roomId}',
      callback: (frame) => _receiveMessage(frame.body),
    );
  }

  /// 수신 메시지 처리
  void _receiveMessage(String? body) {
    if (body != null) {
      final messageData = jsonDecode(body);
      setState(() {
        _messages.insert(0, ChatMessage.fromJson(messageData, _currentUserId!));
      });
      _scrollToBottom();
    }
  }

  /// 메시지 전송
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty && _currentUserId != null) {
      final message = {
        'chatRoomId': widget.roomId,
        'senderId': _currentUserId,
        'message': text,
        'type': 'TEXT',
      };
      _stompClient?.send(
        destination: '/app/message',
        body: jsonEncode(message),
      );
      _messageController.clear();
    }
  }

  /// 스크롤을 맨 아래로 이동
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

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (widget.sizingInformation.screenSize.width / 360.0).clamp(0.8, 1.2);
    return Scaffold(
      body: Center(
        child: Container(
          width: 360.0 * scaleWidth,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ChatAppBar(title: widget.title),
              const SizedBox(height: 10),
              Expanded(
                child: ChatMessageList(
                  messages: _messages,
                  scrollController: _scrollController,
                  roomId: widget.roomId,
                  rentId: _rentId,
                  currentUserId: _currentUserId,
                  ownerId: widget.ownerId,
                ),
              ),
              MessageInputField(
                messageController: _messageController,
                onSendMessage: _sendMessage,
                isSender: true,
                isRenter: widget.ownerId != _currentUserId,
                roomId: widget.roomId,
                rentId: _rentId,
                onRentIdUpdated: _updateRentId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
