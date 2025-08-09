import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/services/socket_service.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/dialogs/block_report_dialog.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:characters/characters.dart';
import 'dart:async';
import 'chat_input_bar.dart';
import 'attachment_picker.dart';
import 'voice_recorder_widget.dart';
import 'camera_preview_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';

// WhatsApp-like typing indicator widget
class TypingIndicator extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final double dotSpacing;
  const TypingIndicator({
    Key? key,
    this.dotColor = Colors.grey,
    this.dotSize = 10,
    this.dotSpacing = 6,
  }) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _dotAnimations = List.generate(3, (i) {
      return Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.dotSize * 2.2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _dotAnimations[i].value),
                child: child,
              );
            },
            child: Container(
              width: widget.dotSize,
              height: widget.dotSize,
              margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing / 2),
              decoration: BoxDecoration(
                color: widget.dotColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String chatTitle;
  final String userId;
  final String userImage;
  final Map<String, dynamic>? initialProductInquiry;
  final Map<String, dynamic>? initialFeedInquiry;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.userImage,
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
  bool _showEmojiPicker = false;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ChatApiService get _chatApiService => ref.watch(chatApiServiceProvider);
  late AnimationController _typingAnimationController;
  bool isBlocked = false;
  List<MessageModel> _messages = [];
  bool _isTyping = false;
  Timer? _typingTimer;
  bool _otherTyping = false;
  String _status = 'offline';
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _allLoaded = false;
  final int _pageSize = 40;

  bool _ignoreScroll = false;
  bool _initialMessagesInserted = false;

  // Group chat state
  bool _isGroup = false;
  List<dynamic> _members = [];
  Map<String, String> _memberNames = {};

  // New state for modular widgets
  late AnimationController _attachmentModalAnimationController;

  bool _showAttachmentPicker = false;

  bool _isRecording = false;
  bool _isRecordingLocked = false; // Add lock state
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;

  final ImagePicker _imagePicker = ImagePicker();
  late final AudioRecorder _audioRecorder;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _attachmentModalAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
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
    _fetchGroupInfo();

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
        // _messages.insert(
        //   0,
        //   MessageModel(
        //     id: 'typing',
        //     sender: widget.userId,
        //     message: 'Typing...',
        //     createdAt: DateTime.now(),
        //   ),
        // );
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
    bool updated = false;
    for (int i = 0; i < _messages.length; i++) {
      final msg = _messages[i];
      if (msg.sender != id && msg.status != 'seen') {
        _socketService.markSeen(msg.id!);
        _messages[i] = msg.copyWith(status: 'seen');
        updated = true;
      }
    }
    if (updated && mounted) {
      setState(() {});
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
    // File message
    if (msg.attachments != null &&
        msg.attachments!.isNotEmpty &&
        msg.attachments!.first.type == 'file') {
      return _buildFileMessageBubble(msg, isMe);
    }
    // Audio message (support both 'audio' and 'voice' types)
    if (msg.attachments != null &&
        msg.attachments!.isNotEmpty &&
        (msg.attachments!.first.type == 'audio' ||
            msg.attachments!.first.type == 'voice')) {
      return _buildAudioMessageBubble(msg, isMe);
    }
    // Video message
    if (msg.attachments != null &&
        msg.attachments!.isNotEmpty &&
        msg.attachments!.first.type == 'video') {
      return _buildVideoMessageBubble(msg, isMe);
    }
    // Image message
    if (msg.attachments != null &&
        msg.attachments!.isNotEmpty &&
        msg.attachments!.first.type == 'image') {
      return _buildImageMessageBubble(msg, isMe);
    }
    // Check if this is a product inquiry message
    if (_isProductInquiryMessage(msg)) {
      return _buildProductInquiryMessage(msg, isMe);
    }

    // Single emoji detection
    final isSingleEmoji = _isSingleEmoji(msg.message ?? '');
    if (isSingleEmoji) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: isMe ? 50 : 16,
            right: isMe ? 16 : 50,
            bottom: 8,
            top: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (_isGroup && !isMe && _memberNames[msg.sender] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
                  child: Text(
                    _memberNames[msg.sender] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              Text(
                msg.message ?? '',
                style: const TextStyle(
                  fontSize: 48,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              if (isMe)
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
                )
              else
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: kSecondaryTextColor.withOpacity(0.7),
                  ),
                ),
            ],
          ),
        ),
      );
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
            if (_isGroup && !isMe && _memberNames[msg.sender] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
                child: Text(
                  _memberNames[msg.sender] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
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

  List _buildChatItems(List<MessageModel> messages) {
    final List items = [];
    DateTime? lastDate;
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

  bool _shouldShowDateHeader(int index) {
    if (index == _messages.length - 1) return true;
    final current = _messages[index].createdAt?.toLocal();
    final next = _messages[index + 1].createdAt?.toLocal();
    if (current == null || next == null) return false;
    final currentDay = DateTime(current.year, current.month, current.day);
    final nextDay = DateTime(next.year, next.month, next.day);
    return currentDay != nextDay;
  }

  Future<void> _fetchGroupInfo() async {
    final chatApi = ref.read(chatApiServiceProvider);
    try {
      final conversations =
          await chatApi.getConversations(pageNo: 1, limit: 100);
      final convo =
          conversations.where((c) => c.id == widget.conversationId).toList();
      if (convo.isNotEmpty && convo.first.isGroup == true) {
        setState(() {
          _isGroup = true;
          _members = convo.first.members ?? [];
          _memberNames = {
            for (var m in _members)
              if (m.id != null && m.name != null) m.id!: m.name!
          };
        });
      }
    } catch (e) {}
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<String> _getAudioFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${_generateRandomId()}.m4a';
  }

  // --- Voice Recording Logic ---
  void _startVoiceRecording() async {
    print('_startVoiceRecording called, _isRecording: $_isRecording');
    if (_isRecording) return; // Prevent multiple starts

    setState(() {
      _isRecording = true;
      _isRecordingLocked = false;
      _recordDuration = Duration.zero;
      _audioFilePath = null;
    });

    // Recording started - no feedback needed since we have animations

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordDuration += const Duration(seconds: 1);
        });
      }
    });

    if (await _audioRecorder.hasPermission()) {
      final filePath = await _getAudioFilePath();
      await _audioRecorder.start(
        const RecordConfig(
            encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: filePath,
      );
      setState(() {
        _audioFilePath = filePath;
      });
    } else {
      // Handle permission denied
      setState(() {
        _isRecording = false;
        _recordDuration = Duration.zero;
      });
      _recordTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Microphone permission required for voice recording'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _stopVoiceRecording() async {
    print('_stopVoiceRecording called, _isRecording: $_isRecording');
    if (!_isRecording) return;

    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _isRecordingLocked = false;
    });
    _recordTimer?.cancel();

    if (path != null && _recordDuration.inSeconds >= 1) {
      // Only send if recording duration is at least 1 second
      _sendMediaMessage(File(path), type: 'voice');
    } else if (path != null && _recordDuration.inSeconds < 1) {
      // Delete short recording
      try {
        await File(path).delete();
      } catch (e) {
        print('Error deleting short recording: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Recording too short - minimum 1 second required'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _cancelVoiceRecording() async {
    print('_cancelVoiceRecording called, _isRecording: $_isRecording');
    if (!_isRecording) return;

    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _isRecordingLocked = false;
      _recordDuration = Duration.zero;
      _audioFilePath = null;
    });
    _recordTimer?.cancel();

    // Delete the recording file
    if (path != null) {
      try {
        await File(path).delete();
      } catch (e) {
        print('Error deleting cancelled recording: $e');
      }
    }
  }

  void _toggleRecordingLock() {
    if (_isRecording) {
      setState(() {
        _isRecordingLocked = !_isRecordingLocked;
      });
    }
  }

  void _showAttachmentModal() {
    setState(() {
      _showAttachmentPicker = true;
    });
    _attachmentModalAnimationController.forward();
  }

  void _hideAttachmentModal() {
    _attachmentModalAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showAttachmentPicker = false;
        });
      }
    });
  }

  Future<void> _pickGalleryImage() async {
    _hideAttachmentModal();
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMediaMessage(File(pickedFile.path), type: 'image');
    }
  }

  Future<void> _pickGalleryVideo() async {
    _hideAttachmentModal();
    final XFile? pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMediaMessage(File(pickedFile.path), type: 'video');
    }
  }

  Future<void> _pickCameraPhoto() async {
    _hideAttachmentModal();
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _sendMediaMessage(File(pickedFile.path), type: 'image');
    }
  }

  Future<void> _pickCameraVideo() async {
    _hideAttachmentModal();
    final XFile? pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _sendMediaMessage(File(pickedFile.path), type: 'video');
    }
  }

  Future<void> _pickDocument() async {
    _hideAttachmentModal();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'rtf',
          'ppt',
          'pptx',
          'xls',
          'xlsx'
        ],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        _sendFileMessage(file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick document: $e"),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _sendFileMessage(File file) async {
    try {
      final url = await imageUpload(file.path);
      _socketService.sendMessage(
        widget.conversationId,
        '',
        attachments: [
          {
            'url': url,
            'type': 'file',
          },
        ],
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
                content: Text("Failed to send file: $error"),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload file: $e"),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _sendMediaMessage(File file, {required String type}) async {
    try {
      String url;
      if (type == 'image' || type == 'video') {
        url = await imageUpload(file.path);
      } else if (type == 'voice') {
        url = await imageUpload(file.path); // Use same upload for audio
      } else if (type == 'file') {
        url = await imageUpload(file.path); // Use same upload for files
      } else {
        throw Exception('Unsupported media type');
      }
      _socketService.sendMessage(
        widget.conversationId,
        '',
        attachments: [
          {'url': url, 'type': type},
        ],
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
                content: Text("Failed to send $type: $error"),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload $type: $e"),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _capturePhoto() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _sendMediaMessage(File(pickedFile.path), type: 'image');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _attachmentModalAnimationController.dispose();
    _typingAnimationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _socketService.sendTyping(widget.conversationId, false);
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    _typingTimer?.cancel();
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
        title: InkWell(
          onTap: () {
            NavigationService navigationService = NavigationService();
            navigationService.pushNamed('ProfilePreviewById',
                arguments: widget.userId);
          },
          child: Row(
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
                child: widget.userImage != ''
                    ? ClipOval(
                        child: Image.network(
                          widget.userImage,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      )
                    : Icon(Icons.person, color: kWhite, size: 20),
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
                      style: kSmallTitleL,
                    ),
                  ],
                ),
              ),
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
                            style: kSmallTitleL,
                          )
                        : Text(
                            'Block',
                            style: kSmallTitleL,
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
      body: Stack(
        children: [
          Column(
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
                      children.add(
                          _buildDateHeader(msg.createdAt ?? DateTime.now()));
                    }
                    children.add(_buildAnimatedMessage(msg, isMe, animation));
                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: children,
                    );
                  },
                ),
              ),
              if (_otherTyping)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, bottom: 8, top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TypingIndicator(
                        dotColor: kPrimaryColor,
                        dotSize: 10,
                        dotSpacing: 5,
                      ),
                    ],
                  ),
                ),
              // --- Voice Recorder Widget ---
              VoiceRecorderWidget(
                isRecording: _isRecording,
                isLocked: _isRecordingLocked,
                duration: _recordDuration,
                onCancel: _cancelVoiceRecording,
                onSend: _stopVoiceRecording,
                onLock: _toggleRecordingLock,
                onUnlock: _toggleRecordingLock,
              ),
              if (!_isRecording)
                SafeArea(
                  child: ChatInputBar(
                    onSendText: (text) {
                      _controller.text = text;
                      _sendMessage();
                    },
                    onAttachment: _showAttachmentModal,
                    onCamera: _capturePhoto,
                    onVoiceRecord: () {
                      if (_isRecording) {
                        _stopVoiceRecording();
                      } else {
                        _startVoiceRecording();
                      }
                    },
                    isRecording: _isRecording,
                    controller: _controller,
                    focusNode: _focusNode,
                    showEmojiPicker: _showEmojiPicker,
                    onToggleEmojiPicker: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                        if (_showEmojiPicker) {
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(context).requestFocus(_focusNode);
                        }
                      });
                    },
                  ),
                ),
            ],
          ),
          if (_showAttachmentPicker)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideAttachmentModal,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: _showAttachmentPicker
                      ? Colors.black.withOpacity(0.3)
                      : Colors.transparent,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _attachmentModalAnimationController,
                        curve: Curves.easeOutCubic,
                      )),
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _attachmentModalAnimationController,
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kCardBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: AttachmentPicker(
                            onGallery: _pickGalleryImage,
                            // onDocument: _pickDocument,
                            onCamera: _pickCameraPhoto,
                            // onContact: () {
                            //   _hideAttachmentModal();
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content:
                            //             Text('Contact selected (placeholder)')),
                            //   );
                            // },
                            // onLocation: () {
                            //   _hideAttachmentModal();
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text(
                            //             'Location selected (placeholder)')),
                            //   );
                            // },
                          ),
                        ),
                      ),
                    ),
                  ),
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

  // Helper: single emoji detection
  bool _isSingleEmoji(String text) {
    final trimmed = text.trim();
    return trimmed.characters.length == 1 &&
        RegExp(r'^\p{Emoji} *$', unicode: true).hasMatch(trimmed);
  }

  Widget _buildAudioMessageBubble(MessageModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 50 : 16,
          right: isMe ? 16 : 50,
          bottom: 8,
          top: 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? kPrimaryColor.withOpacity(0.8) : kCardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isMe ? Colors.transparent : kStrokeColor.withOpacity(0.3),
          ),
        ),
        child: _AudioPlayerWidget(url: msg.attachments!.first.url ?? ''),
      ),
    );
  }

  Widget _buildImageMessageBubble(MessageModel msg, bool isMe) {
    final url = msg.attachments!.first.url ?? '';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: Hero(
                tag: url,
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
          );
        },
        child: Hero(
          tag: url,
          child: Container(
            margin: EdgeInsets.only(
              left: isMe ? 50 : 16,
              right: isMe ? 16 : 50,
              bottom: 8,
              top: 8,
            ),
            decoration: BoxDecoration(
              color:
                  isMe ? kPrimaryColor.withOpacity(0.1) : kCardBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/pngs/icon2.png',
              image: url,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoMessageBubble(MessageModel msg, bool isMe) {
    final url = msg.attachments!.first.url ?? '';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          // TODO: Show fullscreen video (placeholder)
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.black,
              child: _VideoPlayerDialog(url: url),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(
            left: isMe ? 50 : 16,
            right: isMe ? 16 : 50,
            bottom: 8,
            top: 8,
          ),
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: kBlack.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: _VideoThumbnail(url: url),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: kWhite, size: 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileMessageBubble(MessageModel msg, bool isMe) {
    final attachment = msg.attachments!.first;
    final url = attachment.url ?? '';
    final fileName = _extractFileNameFromUrl(url);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 50 : 16,
          right: isMe ? 16 : 50,
          bottom: 8,
          top: 8,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: GestureDetector(
          onTap: () => _downloadAndOpenDocument(url, fileName),
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isMe
                        ? kWhite.withOpacity(0.2)
                        : kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getDocumentIcon(fileName),
                    color: isMe ? kWhite : kPrimaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: TextStyle(
                          color: isMe ? kWhite : kTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to download',
                        style: TextStyle(
                          color: isMe
                              ? kWhite.withOpacity(0.7)
                              : kSecondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.download,
                  color: isMe ? kWhite : kPrimaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'rtf':
        return Icons.text_fields;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _extractFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last;
        if (lastSegment.contains('.')) {
          return lastSegment;
        }
      }
      return 'Document';
    } catch (e) {
      return 'Document';
    }
  }

  Future<void> _downloadAndOpenDocument(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/$fileName";

      final dio = Dio();
      await dio.download(url, savePath);

      final result = await OpenFile.open(savePath);
      debugPrint("OpenFile result: ${result.message}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download document: $e'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}

class _AudioPlayerWidget extends StatefulWidget {
  final String url;
  const _AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });

    // Load duration immediately
    _loadAudioDuration();
  }

  void _loadAudioDuration() async {
    try {
      if (widget.url.isNotEmpty) {
        // Set the source to get duration without playing
        await _audioPlayer.setSource(UrlSource(widget.url));
        // Get the duration
        final duration = await _audioPlayer.getDuration();
        if (mounted && duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      }
    } catch (e) {
      print('Error loading audio duration: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    try {
      setState(() {
        _errorMessage = null;
      });

      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        print('Attempting to play audio from URL: ${widget.url}');

        // Check if URL is valid
        if (widget.url.isEmpty) {
          setState(() {
            _errorMessage = 'No audio URL provided';
          });
          return;
        }

        // Try to play the audio
        await _audioPlayer.play(UrlSource(widget.url,mimeType:'audio/wav' ));
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Audio playback failed';
        _isPlaying = false;
      });
      print('Audio playback exception: $e');

      // Show a snackbar with more details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot play audio: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red, size: 14),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Audio unavailable',
                style: TextStyle(color: Colors.red, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    }

    // Ensure slider bounds are valid
    final maxDuration = _duration.inMilliseconds.toDouble();
    final currentPosition = _position.inMilliseconds.toDouble();
    final sliderValue =
        maxDuration > 0 ? currentPosition.clamp(0.0, maxDuration) : 0.0;

    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: kWhite,
                size: 16,
              ),
              onPressed: _togglePlay,
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(width: 8),

          // Time display and slider
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(
                        fontSize: 11,
                        color: kSecondaryTextColor,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        fontSize: 11,
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),

                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 8),
                  ),
                  child: Slider(
                    value: sliderValue,
                    min: 0,
                    max: maxDuration > 0 ? maxDuration : 1,
                    onChanged: (value) async {
                      try {
                        final pos = Duration(milliseconds: value.toInt());
                        await _audioPlayer.seek(pos);
                      } catch (e) {
                        print('Seek error: $e');
                      }
                    },
                    activeColor: kPrimaryColor,
                    inactiveColor: kStrokeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _VideoThumbnail extends StatefulWidget {
  final String url;
  const _VideoThumbnail({Key? key, required this.url}) : super(key: key);

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized && _controller != null) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      return Container(
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
  }
}

class _VideoPlayerDialog extends StatefulWidget {
  final String url;
  const _VideoPlayerDialog({Key? key, required this.url}) : super(key: key);

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _initialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: kWhite),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          )
        : const Center(child: LoadingAnimation());
  }
}
