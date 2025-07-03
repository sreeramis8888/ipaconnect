import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/services/socket_service.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String chatTitle;
  final String userId;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.chatTitle,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  final SocketService _socketService = SocketService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  late final ChatApiService _chatApiService;
  late AnimationController _typingAnimationController;

  List<MessageModel> _messages = [];
  bool _isTyping = false;
  bool _otherTyping = false;
  String _status = 'offline';
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _allLoaded = false;
  final int _pageSize = 50;

  @override
  void initState() {
    super.initState();
    _chatApiService = ref.read(chatApiServiceProvider);
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _socketService.onMessageReceived = _handleIncomingMessage;
    _socketService.onTyping = _handleTyping;
    _socketService.onUserStatus = _handleUserStatus;
    _socketService.onDelivered = _handleDelivered;
    _socketService.onSeen = _handleSeen;

    _socketService.connect();
    _socketService.listenChatEvents();
    _socketService.joinChat(widget.conversationId);

    _scrollController.addListener(_onScroll);

    _fetchHistory();
  }

  void _handleIncomingMessage(Map<String, dynamic> msg) {
    final newMsg = MessageModel.fromJson(msg);
    if (newMsg.sender != id) setState(() => _messages.add(newMsg));
    _scrollToBottom();

    // Only mark as delivered if the message is from the opposite user
    if (newMsg.sender != widget.userId) {
      _socketService.markDelivered(newMsg.id!);
    }
    // Do NOT mark as seen here; that is handled in _markLastAsSeen when user is at bottom
  }

  void _handleTyping(Map<String, dynamic> data) {
    final isOtherTyping =
        data['user_id'] == widget.userId && data['is_typing'] == true;

    setState(() {
      _otherTyping = isOtherTyping;

      // Remove previous typing message if exists
      _messages.removeWhere((m) => m.id == 'typing');

      if (isOtherTyping) {
        _messages.add(
          MessageModel(
            id: 'typing',
            sender: widget.userId,
            message: 'Typing...',
            createdAt: DateTime.now(),
          ),
        );
        _scrollToBottom();
      }
    });
  }

  void _handleUserStatus(dynamic data) {
    if (data is Map && data['user_id'] == widget.userId) {
      setState(() => _status = data['online'] == true ? 'online' : 'offline');
    }
  }

  void _handleDelivered(Map<String, dynamic> msg) {
    final messageId = msg['id'] ?? msg['_id'];
    final senderId = msg['sender'];
    if (messageId != null && senderId != widget.userId) {
      final idx = _messages.indexWhere((m) => m.id == messageId);
      if (idx != -1 && _messages[idx].status != 'delivered') {
        setState(() {
          _messages[idx] = _messages[idx].copyWith(status: 'delivered');
        });
      }
    }
  }

  void _handleSeen(Map<String, dynamic> msg) {
    final messageId = msg['id'] ?? msg['_id'];
    final senderId = msg['sender'];
    final status = msg['status'];

    if (messageId != null && status == 'seen' && senderId == id) {
      final idx = _messages.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        setState(() {
          _messages[idx] = _messages[idx].copyWith(status: 'seen');
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 40 &&
        !_isLoadingMore &&
        !_allLoaded) {
      _fetchMoreHistory();
    }
    if (_isAtBottom()) {
      _markLastAsSeen();
    }
  }

  bool _isAtBottom() {
    return _scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 20;
  }

  void _markLastAsSeen() {
    if (_messages.isEmpty) return;
    final lastMsg = _messages.last;
    if (lastMsg.sender != id && lastMsg.status != 'seen') {
      _socketService.markSeen(lastMsg.id!);
      setState(() {
        _messages[_messages.length - 1] = lastMsg.copyWith(status: 'seen');
      });
    }
  }

  void _fetchHistory() {
    _isLoadingMore = true;

    _socketService.fetchHistory(
      widget.conversationId,
      page: 1,
      limit: _pageSize,
      onHistory: (messages, totalCount, error) {
        final newMessages = messages
            .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
            .toList();

        setState(() {
          _messages = newMessages;
          _allLoaded = newMessages.length < _pageSize;
          _currentPage = 1;
        });

        _scrollToBottom();
        _isLoadingMore = false;
        if (_isAtBottom()) {
          _markLastAsSeen();
        }
      },
    );
  }

  void _fetchMoreHistory() {
    if (_isLoadingMore || _allLoaded) return;
    _isLoadingMore = true;

    final prevScrollHeight = _scrollController.position.maxScrollExtent;

    _socketService.fetchHistory(
      widget.conversationId,
      page: _currentPage + 1,
      limit: _pageSize,
      onHistory: (messages, totalCount, error) {
        final newMessages = messages
            .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
            .toList();

        setState(() {
          _messages.insertAll(0, newMessages);
          _allLoaded = newMessages.length < _pageSize;
          if (newMessages.isNotEmpty) _currentPage++;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final newScrollHeight = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(newScrollHeight - prevScrollHeight);
        });

        _isLoadingMore = false;
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _socketService.sendMessage(
      widget.conversationId,
      text,
      onAck: (error, message) {
        if (error == null && message != null) {
          setState(() => _messages.add(MessageModel.fromJson(message)));
          _scrollToBottom();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send: $error"),
              backgroundColor: kRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
    );

    _controller.clear();
    setState(() => _isTyping = false);
    _socketService.sendTyping(widget.conversationId, false);
  }

  Widget _buildStatus(MessageModel msg) {
    switch (msg.status) {
      case 'seen':
        return const Icon(Icons.done_all, size: 16, color: kPrimaryColor);
      case 'delivered':
        return const Icon(Icons.done_all, size: 16, color: kSecondaryTextColor);
      default:
        return const Icon(Icons.done, size: 16, color: kGreyDark);
    }
  }

  // Widget _buildTypingIndicator() {
  //   return AnimatedBuilder(
  //     animation: _typingAnimationController,
  //     builder: (context, child) {
  //       return Container(
  //         margin: const EdgeInsets.only(left: 16, right: 100, bottom: 8),
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         decoration: BoxDecoration(
  //           color: kCardBackgroundColor,
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(color: kStrokeColor.withOpacity(0.3)),
  //         ),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ...List.generate(3, (index) {
  //               return AnimatedContainer(
  //                 duration: Duration(milliseconds: 300 + (index * 100)),
  //                 margin: const EdgeInsets.symmetric(horizontal: 2),
  //                 height: 8,
  //                 width: 8,
  //                 decoration: BoxDecoration(
  //                   color: kSecondaryTextColor,
  //                   shape: BoxShape.circle,
  //                 ),
  //               );
  //             }),
  //             const SizedBox(width: 8),
  //             Text(
  //               'Typing...',
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: kSecondaryTextColor,
  //                 fontStyle: FontStyle.italic,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildMessageBubble(MessageModel msg, bool isMe) {
    return Container(
      margin: EdgeInsets.only(
        left: isMe ? 50 : 16,
        right: isMe ? 16 : 50,
        bottom: 4,
        top: 4,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isMe
                  ? LinearGradient(
                      colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMe ? null : kCardBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              border: Border.all(
                color:
                    isMe ? Colors.transparent : kStrokeColor.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.message ?? '',
              style: TextStyle(
                color: isMe ? kWhite : kTextColor,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: kSecondaryTextColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 4),
                _buildStatus(msg),
              ],
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: kSecondaryTextColor.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    // Format as 12-hour time with AM/PM
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _typingAnimationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _socketService.sendTyping(widget.conversationId, false);

    _socketService.onMessageReceived = null;
    _socketService.onTyping = null;
    _socketService.onUserStatus = null;
    _socketService.onDelivered = null;
    _socketService.onSeen = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kCardBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                ),
              ),
              child: const Icon(Icons.person, color: kWhite, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatTitle,
                    style: const TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: _status == 'online' ? kGreen : kGreyDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _status == 'online' ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: _status == 'online'
                              ? kGreen
                              : kSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoadingMore)
            Container(
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.sender == id;
                return _buildMessageBubble(msg, isMe);
              },
            ),
          ),
          // if (_otherTyping) _buildTypingIndicator(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCardBackgroundColor,
              border: Border(
                top: BorderSide(color: kStrokeColor.withOpacity(0.3)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kInputFieldcolor,
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(color: kStrokeColor.withOpacity(0.3)),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(color: kTextColor),
                        maxLines: null,
                        onChanged: (val) {
                          final typing = val.isNotEmpty;
                          if (typing != _isTyping) {
                            setState(() => _isTyping = typing);
                            _socketService.sendTyping(
                                widget.conversationId, typing);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                              color: kSecondaryTextColor.withOpacity(0.7)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: kWhite),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
