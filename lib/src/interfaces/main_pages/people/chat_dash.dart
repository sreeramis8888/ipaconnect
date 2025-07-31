import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/socket_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_screen.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:shimmer/shimmer.dart';

// Typing indicator widget for chat dashboard
class TypingIndicator extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final double dotSpacing;

  const TypingIndicator({
    Key? key,
    this.dotColor = Colors.grey,
    this.dotSize = 8,
    this.dotSpacing = 4,
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
      return Tween<double>(begin: 0, end: -6).animate(
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
      height: widget.dotSize * 2,
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

class ChatDash extends ConsumerStatefulWidget {
  ChatDash({super.key});

  @override
  ConsumerState<ChatDash> createState() => _ChatDashState();
}

class _ChatDashState extends ConsumerState<ChatDash> {
  final Map<String, Map<String, String?>> _userPresence = {};
  late SocketService _socketService;

  List<ConversationModel>? _socketConversations;
  bool _socketLoading = true;
  String? _socketError;

  // Typing state tracking
  Map<String, Set<String>> _typingUsers =
      {}; // conversationId -> Set of typing user IDs

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();

    // Listen for conversation list updates
    _socketService.onConversationsList = (data) {
      try {
        if (data is List) {
          setState(() {
            _socketConversations =
                data.map((json) => ConversationModel.fromJson(json)).toList();
            _socketLoading = false;
            _socketError = null;
          });
        } else {
          setState(() {
            _socketError = 'Invalid data from socket';
            _socketLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _socketError = 'Error parsing socket data: ' + e.toString();
          _socketLoading = false;
        });
      }
    };

    // Listen for new messages to update conversation list
    _socketService.onMessageReceived = _handleNewMessage;

    // Listen for typing events
    _socketService.onTyping = _handleTyping;

    // Enable socket event listening
    _socketService.listenChatEvents();

    // Subscribe to conversations
    _socketService.subscribeConversations(onAck: (err) {
      if (err != null) {
        setState(() {
          _socketError = err;
          _socketLoading = false;
        });
      }
    });
  }

  void _handleNewMessage(Map<String, dynamic> messageData) {
    try {
      print('Received new message: $messageData');

      // Create MessageModel from the received data
      final newMessage = MessageModel.fromJson(messageData);

      // Extract conversation ID and sender from the message
      final conversationId = newMessage.conversation;
      final senderId = newMessage.sender;

      if (conversationId == null) {
        print('No conversation ID found in message');
        return;
      }

      // Don't update unread count for own messages
      final isOwnMessage = senderId == id;
      print('Message from: $senderId, isOwnMessage: $isOwnMessage');

      // Find the conversation in the current list
      if (_socketConversations != null) {
        final conversationIndex = _socketConversations!.indexWhere(
          (conv) => conv.id == conversationId,
        );

        print('Found conversation at index: $conversationIndex');

        if (conversationIndex != -1) {
          // Update the conversation with new message info
          final currentConversation = _socketConversations![conversationIndex];
          final updatedConversation = currentConversation.copyWith(
            lastMessage: newMessage,
            unreadCount: isOwnMessage
                ? currentConversation.unreadCount
                : (currentConversation.unreadCount ?? 0) + 1,
          );

          setState(() {
            // Move the updated conversation to the top
            _socketConversations!.removeAt(conversationIndex);
            _socketConversations!.insert(0, updatedConversation);
            
            // Clear typing indicators for this conversation when a message is received
            _typingUsers.remove(conversationId);
          });

          print(
              'Updated conversation: ${updatedConversation.lastMessage?.message}');
        } else {
          print('Conversation not found in list');
        }
      }
    } catch (e) {
      print('Error handling new message: $e');
    }
  }

  void _handleTyping(Map<String, dynamic> data) {
    try {
      final conversationId = data['conversation_id'] as String?;
      final userId = data['user_id'] as String?;
      final isTyping = data['is_typing'] as bool?;

      if (conversationId == null || userId == null || isTyping == null) {
        print('Invalid typing data: $data');
        return;
      }

      // Don't show typing for own messages
      if (userId == id) return;

      setState(() {
        if (isTyping) {
          // Add user to typing set
          _typingUsers.putIfAbsent(conversationId, () => <String>{});
          _typingUsers[conversationId]!.add(userId);
        } else {
          // Remove user from typing set
          _typingUsers[conversationId]?.remove(userId);
          if (_typingUsers[conversationId]?.isEmpty == true) {
            _typingUsers.remove(conversationId);
          }
        }
      });

      print(
          'Typing update - Conversation: $conversationId, User: $userId, Typing: $isTyping');
    } catch (e) {
      print('Error handling typing event: $e');
    }
  }

  Widget _buildSubtitle(
      ConversationModel conversation, String lastMessageText) {
    final conversationId = conversation.id;
    final isTyping =
        conversationId != null && _typingUsers.containsKey(conversationId);

    if (isTyping) {
      return Row(
        children: [
          TypingIndicator(
            dotColor: kPrimaryColor,
            dotSize: 6,
            dotSpacing: 3,
          ),
          const SizedBox(width: 8),
          Text(
            'typing...',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    } else {
      return Text(
        lastMessageText,
        style: TextStyle(color: kSecondaryTextColor),
      );
    }
  }

  void _resetUnreadCount(String conversationId) {
    if (_socketConversations != null) {
      final conversationIndex = _socketConversations!.indexWhere(
        (conv) => conv.id == conversationId,
      );

      if (conversationIndex != -1) {
        final currentConversation = _socketConversations![conversationIndex];
        final updatedConversation = currentConversation.copyWith(
          unreadCount: 0, // Reset unread count
        );

        setState(() {
          _socketConversations![conversationIndex] = updatedConversation;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up socket listeners
    _socketService.onMessageReceived = null;
    _socketService.onConversationsList = null;
    _socketService.onTyping = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_socketLoading) {
      return const Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(child: LoadingAnimation()),
      );
    }
    if (_socketError != null) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(child: Text('')),
      );
    }
    final chats = _socketConversations;
    if (chats == null || chats.isEmpty) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Image.asset(
                'assets/pngs/nochat.png',
                color: kWhite,
              )),
            ),
            Text('No chat yet!', style: kBodyTitleB),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final conversation = chats[index];
          String lastMessageText = '';
          if (conversation.lastMessage != null) {
            lastMessageText = conversation.lastMessage?.message ?? '';
            if (lastMessageText.length > 30) {
              lastMessageText = '${lastMessageText.substring(0, 30)}...';
            }
          }
          // Find the other participant (for 1-to-1 chat)
          final otherMember = (conversation.members ?? []).firstWhere(
            (member) => member.id != id,
            orElse: () => UserModel(id: '', name: '', email: ''),
          );
          return Column(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  if (otherMember.id == '') {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(conversation.name ?? 'Chat'),
                      subtitle: Text(lastMessageText),
                      trailing: const SizedBox.shrink(),
                    );
                  }
                  final userAsync = ref.watch(
                      getUserDetailsByIdProvider(userId: otherMember.id ?? ''));
                  return userAsync.when(
                    loading: () => ListTile(
                      leading: const CircleAvatar(child: LoadingAnimation()),
                      title: Text(conversation.name ?? 'Chat'),
                      subtitle: Text(lastMessageText),
                      trailing: const SizedBox.shrink(),
                    ),
                    error: (error, stack) => ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.error)),
                      title: Text(conversation.name ?? 'Chat'),
                      subtitle: Text(lastMessageText),
                      trailing: const SizedBox.shrink(),
                    ),
                    data: (user) => ListTile(
                      tileColor: kCardBackgroundColor,
                      leading: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipOval(
                          child: Image.network(
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Shimmer.fromColors(
                                baseColor: kCardBackgroundColor,
                                highlightColor: kStrokeColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kCardBackgroundColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            },
                            user?.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return SvgPicture.asset(
                                  'assets/svg/icons/dummy_person_small.svg');
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        user?.name ?? conversation.name ?? 'Chat',
                        style: kBodyTitleR,
                      ),
                      subtitle: _buildSubtitle(conversation, lastMessageText),
                      trailing: conversation.unreadCount != 0
                          ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: kRed, shape: BoxShape.circle),
                              child: Center(
                                  child: Text(
                                      style: kSmallerTitleR,
                                      conversation.unreadCount.toString())),
                            )
                          : SizedBox.shrink(),
                      onTap: () async {
                        // Reset unread count for this conversation
                        _resetUnreadCount(conversation.id ?? '');

                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userImage: user?.image ?? '',
                            conversationId: conversation.id ?? '',
                            chatTitle: conversation.isGroup == true
                                ? conversation.name ?? ''
                                : user?.name ?? '',
                            userId: user?.id ?? '',
                          ),
                        ));
                        // Re-fetch or re-subscribe to conversations after returning
                        _socketService.subscribeConversations(onAck: (err) {
                          if (err != null) {
                            setState(() {
                              _socketError = err;
                              _socketLoading = false;
                            });
                          }
                        });
                      },
                    ),
                  );
                },
              ),
              const Divider(
                thickness: .2,
                color: kPrimaryColor,
                height: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
