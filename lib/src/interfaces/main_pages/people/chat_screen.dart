import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/socket_service.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/dialogs/block_report_dialog.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String chatTitle;
  final String userId;
  final Map<String, dynamic>? initialProductInquiry;
  final Map<String, dynamic>? initialFeedInquiry;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.chatTitle,
    required this.userId,
    this.initialProductInquiry,
    this.initialFeedInquiry,
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

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ChatApiService get _chatApiService => ref.watch(chatApiServiceProvider);
  late AnimationController _typingAnimationController;
  bool isBlocked = false;
  List<MessageModel> _messages = [];
  bool _isTyping = false;
  bool _otherTyping = false;
  String _status = 'offline';
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _allLoaded = false;
  final int _pageSize = 40;

  bool _ignoreScroll = false;
  bool _initialMessagesInserted = false;

  @override
  void initState() {
    super.initState();
    // _loadBlockStatus(); // Remove this call from initState
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _socketService.onMessageReceived = _handleIncomingMessage;
    _socketService.onTyping = _handleTyping;
    _socketService.onUserStatus = _handleUserStatus;
    _socketService.onDelivered = _handleDelivered;
    _socketService.onSeen = _handleSeen;

    _socketService.listenChatEvents();
    _socketService.joinChat(widget.conversationId);

    _scrollController.addListener(_onScroll);

    _fetchHistory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialProductInquiry != null) {
        _sendProductInquiry();
      } else if (widget.initialFeedInquiry != null) {
        _sendFeedInquiry();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Block status logic moved here
    final asyncUser = ref.read(userProvider);
    asyncUser.whenData(
      (user) {
        if (!mounted) return;
        setState(() {
          if (user.blockedUsers != null) {
            isBlocked = user.blockedUsers!
                .any((blockedUser) => blockedUser == widget.userId);
          }
        });
      },
    );
  }

  void _handleIncomingMessage(Map<String, dynamic> msg) {
    final newMsg = MessageModel.fromJson(msg);
    if (newMsg.sender != id) {
      if (!mounted) return;
      setState(() {
        _messages.insert(0, newMsg);
        _listKey.currentState
            ?.insertItem(0, duration: const Duration(milliseconds: 400));
      });
    }
    _scrollToBottom();

    if (newMsg.sender != widget.userId) {
      _socketService.markDelivered(newMsg.id!);
    }

    // Mark as seen if the message is from the chat partner and you are at the bottom
    if (newMsg.sender == widget.userId && _isAtBottom()) {
      _socketService.markSeen(newMsg.id!);
      if (!mounted) return;
      setState(() {
        _messages[0] = newMsg.copyWith(status: 'seen');
      });
    }
  }

  void _handleTyping(Map<String, dynamic> data) {
    final isOtherTyping =
        data['user_id'] == widget.userId && data['is_typing'] == true;

    if (!mounted) return;
    setState(() {
      _otherTyping = isOtherTyping;

      _messages.removeWhere((m) => m.id == 'typing');

      if (isOtherTyping) {
        _messages.insert(
          0,
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
      if (!mounted) return;
      setState(() => _status = data['online'] == true ? 'online' : 'offline');
    } else if (data is List) {
      for (final userStatus in data) {
        if (userStatus is Map && userStatus['user_id'] == widget.userId) {
          if (!mounted) return;
          setState(() =>
              _status = userStatus['online'] == true ? 'online' : 'offline');
          break;
        }
      }
    }
  }

  void _handleDelivered(Map<String, dynamic> msg) {
    final messageId = msg['id'] ?? msg['_id'];
    final senderId = msg['sender'];
    if (messageId != null && senderId != widget.userId) {
      final idx = _messages.indexWhere((m) => m.id == messageId);
      if (idx != -1 && _messages[idx].status != 'delivered') {
        if (!mounted) return;
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
        if (!mounted) return;
        setState(() {
          _messages[idx] = _messages[idx].copyWith(status: 'seen');
        });
      }
    }
  }

  void _onScroll() {
    if (_ignoreScroll) return;

    final pixels = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    if ((pixels - maxScrollExtent).abs() < 2.0 &&
        !_isLoadingMore &&
        !_allLoaded) {
      print(
          'Triggering load: pixels=$pixels, maxScrollExtent=$maxScrollExtent');
      _fetchMoreHistory();
    }

    if (pixels <= 50) {
      _markLastAsSeen();
    }
  }

  bool _isAtBottom() {
    return _scrollController.hasClients &&
        _scrollController.position.pixels <= 50;
  }

  void _markLastAsSeen() {
    if (_messages.isEmpty) return;
    final lastMsg = _messages.first; // Use first for newest message
    if (lastMsg.sender != id && lastMsg.status != 'seen') {
      _socketService.markSeen(lastMsg.id!);
      if (!mounted) return;
      setState(() {
        _messages[0] = lastMsg.copyWith(status: 'seen');
      });
    }
  }

  void _fetchHistory() {
    if (!mounted) return;
    setState(() {
      _isLoadingMore = true;
    });

    _socketService.fetchHistory(
      widget.conversationId,
      page: 1,
      limit: _pageSize,
      onHistory: (messages, totalCount, error) async {
        if (!mounted) return;
        final newMessages = messages
            .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
            .toList();

        setState(() {
          _messages.clear();
          _allLoaded = newMessages.length < _pageSize;
          _currentPage = 1;
          _isLoadingMore = false;
        });
        // Insert initial messages with animation
        if (_listKey.currentState != null) {
          int insertIndex = 0;
          for (final msg in newMessages) {
            _messages.insert(insertIndex, msg);
            _listKey.currentState!.insertItem(insertIndex,
                duration: Duration(milliseconds: 200 + insertIndex * 30));
            insertIndex++;
            await Future.delayed(const Duration(milliseconds: 20));
          }
        } else {
          setState(() {
            _messages = newMessages;
          });
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
          if (_isAtBottom()) {
            _markLastAsSeen();
          }
        });
      },
    );
  }

  void _fetchMoreHistory() {
    if (_isLoadingMore || _allLoaded) return;

    print(
        'Fetching more history - Page: $_currentPage, Loading: $_isLoadingMore');

    if (!mounted) return;
    setState(() {
      _isLoadingMore = true;
    });

    _socketService.fetchHistory(
      widget.conversationId,
      page: _currentPage + 1,
      limit: _pageSize,
      onHistory: (messages, totalCount, error) async {
        if (!mounted) return;
        final newMessages = messages
            .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
            .toList();

        print('Received  [newMessages.length] new messages');

        if (_listKey.currentState != null) {
          int insertIndex = _messages.length;
          for (final msg in newMessages) {
            _messages.add(msg);
            _listKey.currentState!.insertItem(insertIndex,
                duration: Duration(milliseconds: 200 + (insertIndex) * 30));
            insertIndex++;
            await Future.delayed(const Duration(milliseconds: 20));
          }
        } else {
          setState(() {
            _messages.addAll(newMessages);
          });
        }
        setState(() {
          _allLoaded = newMessages.length < _pageSize;
          if (newMessages.isNotEmpty) {
            _currentPage++;
          }
          _isLoadingMore = false;
        });

        if (newMessages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _ignoreScroll = true;
              final offsetFromBottom =
                  _scrollController.position.maxScrollExtent -
                      _scrollController.position.pixels;

              final newMaxScroll = _scrollController.position.maxScrollExtent;
              final newPixels = newMaxScroll - offsetFromBottom;
              _scrollController.jumpTo(newPixels.clamp(0.0, newMaxScroll));
              Future.delayed(const Duration(milliseconds: 100), () {
                _ignoreScroll = false;
              });
            }
          });
        }
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _sendProductInquiry() {
    final productInquiry = widget.initialProductInquiry!;
    final product = productInquiry['product'];
    final category = productInquiry['category'];

    // Create product inquiry message
    final inquiryMessage = '''
🔍 Product Inquiry

Product Details:
 ${product.name}
$category
• Price: ₹${product.discountPrice.toStringAsFixed(0)} (Original: ₹${product.actualPrice.toStringAsFixed(0)})

Specifications:
${product.specifications.isNotEmpty ? product.specifications.map((spec) => '• $spec').join('\n') : '• No specifications available'}

I'm interested in this product. Could you provide more information?
''';

    // Get the first product image for attachment
    final productImageUrl =
        product.images.isNotEmpty ? product.images.first.url : null;

    final attachments = productImageUrl != null
        ? <Map<String, dynamic>>[
            {
              'url': productImageUrl,
              'type': 'image',
            }
          ]
        : <Map<String, dynamic>>[];

    _socketService.sendMessage(
      widget.conversationId,
      inquiryMessage,
      attachments: attachments,
      onAck: (error, message) {
        if (!mounted) return;
        if (error == null && message != null) {
          setState(() {
            _messages.insert(0, MessageModel.fromJson(message));
            _listKey.currentState
                ?.insertItem(0, duration: const Duration(milliseconds: 400));
          });
          _scrollToBottom();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send product inquiry: $error"),
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
  }

  void _sendFeedInquiry() {
    final feedInquiry = widget.initialFeedInquiry!;
    final feed = feedInquiry['feed'];
    final author = feedInquiry['author'];

    final inquiryMessage = '''
📝 Feed Enquiry

Feed Content:
${feed.content}

Author: ${author.name ?? ''}
Posted: ${feed.createdAt != null ? feed.createdAt.toString() : ''}

I'm interested in this feed. Could you provide more information?
''';

    final feedImageUrl =
        feed.media != null && feed.media.isNotEmpty ? feed.media : null;
    final attachments = feedImageUrl != null
        ? <Map<String, dynamic>>[
            {
              'url': feedImageUrl,
              'type': 'image',
            }
          ]
        : <Map<String, dynamic>>[];

    _socketService.sendMessage(
      widget.conversationId,
      inquiryMessage,
      attachments: attachments,
      onAck: (error, message) {
        if (!mounted) return;
        if (error == null && message != null) {
          setState(() {
            _messages.insert(0, MessageModel.fromJson(message));
            _listKey.currentState
                ?.insertItem(0, duration: const Duration(milliseconds: 400));
          });
          _scrollToBottom();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send feed enquiry: $error"),
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
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _socketService.sendMessage(
      widget.conversationId,
      text,
      onAck: (error, message) {
        if (!mounted) return;
        if (error == null && message != null) {
          setState(() {
            _messages.insert(0, MessageModel.fromJson(message));
            _listKey.currentState
                ?.insertItem(0, duration: const Duration(milliseconds: 400));
          });
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
    if (!mounted) return;
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

  Widget _buildMessageBubble(MessageModel msg, bool isMe) {
    // Check if this is a product inquiry message
    if (_isProductInquiryMessage(msg)) {
      return _buildProductInquiryMessage(msg, isMe);
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.message ?? '',
                    style: TextStyle(
                      color: isMe ? kWhite : kTextColor,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  // Show attachments if any
                  if (msg.attachments != null && msg.attachments!.isNotEmpty)
                    ...msg.attachments!
                        .map((attachment) => _buildAttachment(attachment, isMe))
                        .toList(),
                ],
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
      ),
    );
  }

  bool _isProductInquiryMessage(MessageModel msg) {
    return msg.message?.contains('🔍 **Product Inquiry**') == true;
  }

  Widget _buildProductInquiryMessage(MessageModel msg, bool isMe) {
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
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              gradient: isMe
                  ? LinearGradient(
                      colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMe ? null : kCardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                if (msg.attachments != null && msg.attachments!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        msg.attachments!.first.url ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: kCardBackgroundColor,
                          child: Icon(
                            Icons.broken_image,
                            color: kSecondaryTextColor,
                            size: 40,
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: kCardBackgroundColor,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: kPrimaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                // Product inquiry content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: isMe ? kWhite : kPrimaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Product Inquiry',
                            style: TextStyle(
                              color: isMe ? kWhite : kTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        msg.message ?? '',
                        style: TextStyle(
                          color: isMe ? kWhite : kTextColor,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _buildAttachment(Attachment attachment, bool isMe) {
    if (attachment.type == 'image') {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            attachment.url ?? '',
            width: 200,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 200,
              height: 150,
              color: kCardBackgroundColor,
              child: Icon(
                Icons.broken_image,
                color: kSecondaryTextColor,
                size: 40,
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200,
                height: 150,
                color: kCardBackgroundColor,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: kPrimaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final localDateTime = dateTime.toLocal();
    // Format as 12-hour time with AM/PM
    final hour = localDateTime.hour % 12 == 0 ? 12 : localDateTime.hour % 12;
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final ampm = localDateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  // Helper to format date headers
  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(localDate.year, localDate.month, localDate.day);
    if (messageDay == today) {
      return 'Today';
    } else if (messageDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${localDate.day.toString().padLeft(2, '0')}-${localDate.month.toString().padLeft(2, '0')}-${localDate.year}';
    }
  }

  // Build a list of items (date header or message)
  List _buildChatItems(List<MessageModel> messages) {
    final List items = [];
    DateTime? lastDate;
    // Iterate from oldest to newest
    for (final msg in messages.reversed) {
      final msgDate = msg.createdAt?.toLocal();
      if (msgDate == null) continue;
      final msgDay = DateTime(msgDate.year, msgDate.month, msgDate.day);
      if (lastDate == null || msgDay != lastDate) {
        items.add({'type': 'header', 'date': msgDate});
        lastDate = msgDay;
      }
      items.add({'type': 'message', 'msg': msg});
    }
    // Reverse for ListView reverse: true
    return items.reversed.toList();
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        _formatDateHeader(date),
        style: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  // Helper to determine if a date header should be shown before a message
  bool _shouldShowDateHeader(int index) {
    if (index == _messages.length - 1) return true; // Last (oldest) message
    final current = _messages[index].createdAt?.toLocal();
    final next = _messages[index + 1].createdAt?.toLocal();
    if (current == null || next == null) return false;
    final currentDay = DateTime(current.year, current.month, current.day);
    final nextDay = DateTime(next.year, next.month, next.day);
    return currentDay != nextDay;
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
    // final chatItems = _buildChatItems(_messages);
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
          PopupMenuButton<String>(
            color: kCardBackgroundColor,
            icon: const Icon(
              Icons.more_vert,
              color: kWhite,
            ),
            onSelected: (value) {
              if (value == 'report') {
                showReportPersonDialog(
                  context: context,
                  onReportStatusChanged: () {},
                  reportType: 'Users',
                  reportedItemId: widget.userId ?? '',
                );
              } else if (value == 'block') {
                showBlockPersonDialog(
                  context: context,
                  userId: widget.userId ?? '',
                  onBlockStatusChanged: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (!mounted) return;
                      setState(() {
                        isBlocked = !isBlocked;
                      });
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report, color: kPrimaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Report',
                      style: kSmallTitleR,
                    ),
                  ],
                ),
              ),
              // Divider for visual separation
              const PopupMenuDivider(height: 1),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block),
                    SizedBox(width: 8),
                    isBlocked
                        ? Text(
                            'Unblock',
                            style: kSmallTitleR,
                          )
                        : Text(
                            'Block',
                            style: kSmallTitleR,
                          ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 40),
          )
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isLoadingMore && !_allLoaded ? 60 : 0,
            child: _isLoadingMore && !_allLoaded
                ? Container(
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: LoadingAnimation(),
                    ),
                  )
                : null,
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                final msg = _messages[index];
                final isMe = msg.sender == id;
                final List<Widget> children = [];
                if (_shouldShowDateHeader(index)) {
                  children
                      .add(_buildDateHeader(msg.createdAt ?? DateTime.now()));
                }
                children.add(_buildAnimatedMessage(msg, isMe, animation));
                return Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: children,
                );
              },
            ),
          ),
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

  Widget _buildAnimatedMessage(
      MessageModel msg, bool isMe, Animation<double> animation) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      axisAlignment: 0.0,
      child: FadeTransition(
        opacity: animation,
        child: _buildMessageBubble(msg, isMe),
      ),
    );
  }
}
