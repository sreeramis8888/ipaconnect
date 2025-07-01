// import 'package:familytree/src/data/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
// import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
// import 'package:familytree/src/data/constants/color_constants.dart';
// import 'package:familytree/src/data/constants/style_constants.dart';
// import 'package:familytree/src/data/models/msg_model.dart';
// import 'package:familytree/src/data/notifiers/user_notifier.dart';
// import 'package:familytree/src/interface/components/Dialogs/blockPersonDialog.dart';
// import 'package:familytree/src/interface/components/Dialogs/report_dialog.dart';
// import 'package:familytree/src/interface/components/common/own_message_card.dart';
// import 'package:familytree/src/interface/components/common/reply_card.dart';
// import 'package:familytree/src/interface/components/custom_widgets/blue_tick_names.dart';
// import 'package:familytree/src/interface/screens/main_pages/profile/profile_preview.dart';
// import 'package:familytree/src/data/models/chat_conversation_model.dart';
// import 'package:familytree/src/data/models/chat_message_model.dart';
// import 'package:intl/intl.dart';
// import 'package:familytree/src/data/services/socket_service.dart';
// import 'package:familytree/src/data/models/chat_model.dart';
// import 'dart:async';

// class IndividualPage extends StatefulWidget {
//   final ChatConversation conversation;
//   final String currentUserId;
//   const IndividualPage(
//       {required this.conversation, required this.currentUserId, super.key});

//   @override
//   State<IndividualPage> createState() => _IndividualPageState();
// }

// class _IndividualPageState extends State<IndividualPage>
//     with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FocusNode _focusNode = FocusNode();
//   List<ChatMessage> messages = [];
//   late SocketService socketService;
//   bool socketConnected = false;
//   bool isTyping = false;
//   String? typingUserId;
//   bool _hasSentTyping = false;
//   Timer? _typingTimer;
//   String? otherUserId;
//   String otherUserStatus = '';
//   late AnimationController _sendButtonController;
//   late AnimationController _typingController;
//   late Animation<double> _sendButtonAnimation;
//   late Animation<double> _typingAnimation;
//   bool _isInputFocused = false;

//   // Chat theme colors using your app's color scheme
//   static const Color kPrimaryColor = Color(0xFFE30613);
//   static const Color kSecondaryColor = Color(0xFFF3EFEF);
//   static const Color kPrimaryLightColor = Color(0xFFE83A33);
//   static const Color kTertiary = Color(0xFFE8EAED);
//   static const Color kInputFieldcolor = Color(0xFF6F7782);
//   static const Color kWhite = Color.fromARGB(255, 255, 255, 255);
//   static const Color kGrey = Color.fromARGB(255, 200, 200, 200);
//   static const Color kGreyLight = Color(0xFFCCCCCC);
//   static const Color kGreyDark = Color.fromARGB(255, 118, 121, 124);
//   static const Color kGreyDarker = Color(0xFF585858);
//   static const Color kRed = Color(0xFFEB5757);
//   static const Color kRedDark = Color(0xFFC9300E);
//   static const Color kBlack = Color.fromARGB(255, 5, 5, 5);
//   static const Color kBlack54 = Color(0xFF8A000000);
//   static const Color kGreen = Color.fromARGB(255, 76, 175, 80);
//   static const Color kGreenLight = Color.fromARGB(255, 192, 252, 194);
//   static const Color kBlue = Color(0xFF2B74E1);
//   static const Color kLightGreen = Color.fromARGB(255, 192, 252, 194);

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize animation controllers
//     _sendButtonController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _typingController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _sendButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _sendButtonController, curve: Curves.elasticOut),
//     );
    
//     _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
//     );

//     // Focus node listener
//     _focusNode.addListener(() {
//       setState(() {
//         _isInputFocused = _focusNode.hasFocus;
//       });
//     });

//     socketService = SocketService();
//     socketService.connect();
//     socketService.joinRoom(widget.conversation.id ?? '');
//     socketService.onMessage((data) {
//       if (data['conversationId'] == widget.conversation.id && data['message'] != null) {
//         final newMsg = ChatMessage.fromJson(data['message']);
//         setState(() {
//           messages.add(newMsg);
//         });
//         // Emit delivered if not own message
//         if (newMsg.sender?.id != widget.currentUserId) {
//           socketService.emitMessageDelivered(newMsg.id ?? '');
//         }
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollToBottom();
//         });
//       }
//     });

//     // Find the other participant's userId
//     final other = widget.conversation.participants.firstWhere(
//       (p) => isOtherParticipant(p.userId, widget.currentUserId),
//       orElse: () => Participant(userId: '', isActive: false),
//     );
//     otherUserId = other.userId;
    
//     // Listen for presence updates for the other user
//     socketService.onPresenceUpdate((userId, status) {
//       if (userId == otherUserId) {
//         setState(() {
//           otherUserStatus = status;
//         });
//       }
//     });

//     socketService.onUserTyping((userId, conversationId) {
//       if (conversationId == widget.conversation.id &&
//           userId != widget.currentUserId) {
//         setState(() {
//           isTyping = true;
//           typingUserId = userId;
//         });
//         _typingController.repeat(reverse: true);
//       }
//     });
    
//     socketService.onUserStopTyping((userId, conversationId) {
//       if (conversationId == widget.conversation.id &&
//           userId != widget.currentUserId) {
//         setState(() {
//           isTyping = false;
//           typingUserId = null;
//         });
//         _typingController.stop();
//       }
//     });

//     fetchInitialMessages();
//   }

//   Future<void> fetchInitialMessages() async {
//     final api = ChatApi();
//     final fetched = await api.fetchMessages(widget.conversation.id ?? '');
//     setState(() {
//       messages = fetched;
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToBottom();
//     });

//     // Emit "message read" for unread messages
//     for (final msg in fetched) {
//       final isOwn = msg.sender?.id == widget.currentUserId;
//       final alreadyRead = msg.readBy.any((r) => r.userId == widget.currentUserId);
//       if (!isOwn && !alreadyRead && msg.id != null) {
//         socketService.emitMessageRead(msg.id!);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _typingTimer?.cancel();
//     _controller.dispose();
//     _scrollController.dispose();
//     _focusNode.dispose();
//     _sendButtonController.dispose();
//     _typingController.dispose();
//     socketService.leaveRoom(widget.conversation.id ?? '');
//     socketService.disconnect();
//     super.dispose();
//   }

//   void sendTyping() {
//     if (!_hasSentTyping) {
//       socketService.emitTypingStart(
//           widget.conversation.id, widget.currentUserId);
//       _hasSentTyping = true;
//     }
//   }

//   void sendStopTyping() {
//     if (_hasSentTyping) {
//       socketService.emitTypingStop(
//           widget.conversation.id, widget.currentUserId);
//       _hasSentTyping = false;
//     }
//   }

//   void sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       // Haptic feedback
//       HapticFeedback.lightImpact();
      
//       final msg = {
//         'conversationId': widget.conversation.id,
//         'senderId': widget.currentUserId,
//         'content': _controller.text,
//         'messageType': 'text',
//         'createdAt': DateTime.now().toIso8601String(),
//       };
//       final api = ChatApi();
//       api.sendMessage(
//         widget.conversation.id ?? '',
//         _controller.text,
//       );
//       setState(() {
//         messages.add(ChatMessage.fromJson(msg));
//       });
//       _controller.clear();
//       sendStopTyping();
//       _sendButtonController.reverse();
      
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollToBottom();
//       });
//     }
//   }

//   void _onInputChanged(String value) {
//     if (value.isNotEmpty) {
//       if (!_sendButtonController.isCompleted) {
//         _sendButtonController.forward();
//       }
//       sendTyping();
//       _typingTimer?.cancel();
//       _typingTimer = Timer(const Duration(seconds: 2), () {
//         sendStopTyping();
//       });
//     } else {
//       if (_sendButtonController.isCompleted) {
//         _sendButtonController.reverse();
//       }
//       sendStopTyping();
//       _typingTimer?.cancel();
//     }
//   }

//   String timeAgo(DateTime dateTime) {
//     final now = DateTime.now();
//     final diff = now.difference(dateTime);
//     if (diff.inSeconds < 60) return 'just now';
//     if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
//     if (diff.inHours < 24) return '${diff.inHours} hr ago';
//     return '${diff.inDays} days ago';
//   }

//   bool isOtherParticipant(dynamic userId, String currentUserId) {
//     if (userId is String) return userId != currentUserId;
//     if (userId is ChatUser) return userId.id != currentUserId;
//     return false;
//   }

//   Widget _buildStatusIndicator() {
//     Color statusColor;
//     switch (otherUserStatus) {
//       case 'online':
//         statusColor = kGreen;
//         break;
//       case 'away':
//       case 'busy':
//         statusColor = Colors.orange;
//         break;
//       default:
//         statusColor = kGreyDark;
//     }

//     return Container(
//       width: 12,
//       height: 12,
//       decoration: BoxDecoration(
//         color: statusColor,
//         shape: BoxShape.circle,
//         border: Border.all(            color: kGrey, width: 2),
//       ),
//     );
//   }

//   Widget _buildTypingIndicator() {
//     return AnimatedBuilder(
//       animation: _typingAnimation,
//       builder: (context, child) {
//         return Container(
//           margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: kGrey,
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 4,
//                 offset: const Offset(0, 1),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ...List.generate(3, (index) {
//                 return AnimatedContainer(
//                   duration: Duration(milliseconds: 300 + (index * 100)),
//                   margin: const EdgeInsets.only(right: 3),
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: kGreyDark.withOpacity(0.5 + (_typingAnimation.value * 0.5)),
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               }),
//               const SizedBox(width: 8),
//               Text(
//                 'typing...',
//                 style: TextStyle(
//                   color: kGreyDark,
//                   fontSize: 12,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage message, bool isOwn, String time) {
//     bool isDelivered = false;
//     bool isRead = false;
//     if (isOwn) {
//       isDelivered = message.deliveredTo.any((d) => d.userId != widget.currentUserId);
//       isRead = message.readBy.any((r) => r.userId != widget.currentUserId);
//     }

//     return Container(
//       margin: EdgeInsets.only(
//         left: isOwn ? 64 : 16,
//         right: isOwn ? 16 : 64,
//         top: 2,
//         bottom: 2,
//       ),
//       child: Align(
//         alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration: BoxDecoration(
//             color: isOwn ? kSecondaryColor : kWhite,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(18),
//               topRight: const Radius.circular(18),
//               bottomLeft: Radius.circular(isOwn ? 18 : 4),
//               bottomRight: Radius.circular(isOwn ? 4 : 18),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 4,
//                 offset: const Offset(0, 1),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 message.content ?? '',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: kBlack.withOpacity(0.85),
//                   height: 1.3,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     time,
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: kGreyDark,
//                     ),
//                   ),
//                   if (isOwn) ...[
//                     const SizedBox(width: 4),
//                     Icon(
//                       isRead
//                           ? Icons.done_all
//                           : isDelivered
//                               ? Icons.done_all
//                               : Icons.done,
//                       size: 14,
//                       color: isRead
//                           ? kGreen
//                           : kGreyDark,
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<ChatMessage> sortedMessages = List.from(messages)
//       ..sort((a, b) {
//         final aTime = a.createdAt is DateTime
//             ? a.createdAt as DateTime
//             : (a.createdAt != null ? DateTime.tryParse(a.createdAt.toString()) : null) ?? DateTime.fromMillisecondsSinceEpoch(0);
//         final bTime = b.createdAt is DateTime
//             ? b.createdAt as DateTime
//             : (b.createdAt != null ? DateTime.tryParse(b.createdAt.toString()) : null) ?? DateTime.fromMillisecondsSinceEpoch(0);
//         return aTime.compareTo(bTime);
//       });

//     return Scaffold(
//       backgroundColor: kTertiary,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: kPrimaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: kWhite),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: kGrey,
//                   backgroundImage: widget.conversation.avatar != null &&
//                           widget.conversation.avatar!.isNotEmpty
//                       ? NetworkImage(widget.conversation.avatar!)
//                       : null,
//                   child: widget.conversation.avatar == null ||
//                           widget.conversation.avatar!.isEmpty
//                       ? Text(
//                           widget.conversation.participants.length > 1 &&
//                                   widget.conversation.participants[1].fullName != null &&
//                                   widget.conversation.participants[1].fullName!.isNotEmpty
//                               ? widget.conversation.participants[1].fullName![0].toUpperCase()
//                               : '?',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: kWhite,
//                           ),
//                         )
//                       : null,
//                 ),
//                 if (otherUserStatus == 'online')
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: _buildStatusIndicator(),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.conversation.name ?? 'Chat',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: kWhite,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     otherUserStatus.isNotEmpty
//                         ? otherUserStatus[0].toUpperCase() + otherUserStatus.substring(1)
//                         : (widget.conversation.lastActivity != null
//                             ? 'Last seen ' + timeAgo(widget.conversation.lastActivity!)
//                             : 'Offline'),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: kWhite.withOpacity(0.8),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert, color: kWhite),
//             onSelected: (value) {
//               // Handle menu actions
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(value: 'view_contact', child: Text('View Contact')),
//               const PopupMenuItem(value: 'search', child: Text('Search')),
//               const PopupMenuItem(value: 'mute', child: Text('Mute Notifications')),
//             ],
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/chat_background.png'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.white.withOpacity(0.1),
//               BlendMode.lighten,
//             ),
//           ),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   if (isTyping) _buildTypingIndicator(),
//                   Expanded(
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       itemCount: sortedMessages.length,
//                       itemBuilder: (context, index) {
//                         final message = sortedMessages[index];
//                         final isOwn = message.sender?.id == widget.currentUserId;

//                         // Format time
//                         String time = '';
//                         if (message.createdAt != null) {
//                           final dt = message.createdAt is DateTime
//                               ? message.createdAt as DateTime
//                               : DateTime.tryParse(message.createdAt.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
//                           time = DateFormat('h:mm a').format(dt.toLocal());
//                         }

//                         return _buildMessageBubble(message, isOwn, time);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: kWhite,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, -1),
//                   ),
//                 ],
//               ),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: kTertiary,
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(
//                             color: _isInputFocused ? kPrimaryColor.withOpacity(0.3) : Colors.transparent,
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.emoji_emotions_outlined, 
//                                   color: kInputFieldcolor),
//                               onPressed: () {
//                                 // Emoji picker functionality
//                               },
//                             ),
//                             Expanded(
//                               child: TextField(
//                                 controller: _controller,
//                                 focusNode: _focusNode,
//                                 onChanged: _onInputChanged,
//                                 maxLines: 5,
//                                 minLines: 1,
//                                 style: const TextStyle(fontSize: 16),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Type a message",
//                                   hintStyle: TextStyle(color: kInputFieldcolor),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 10),
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.attach_file, color: kInputFieldcolor),
//                               onPressed: () {
//                                 // Attachment functionality
//                               },
//                             ),
//                             if (_controller.text.isEmpty)
//                               IconButton(
//                                 icon: Icon(Icons.camera_alt, color: kInputFieldcolor),
//                                 onPressed: () {
//                                   // Camera functionality
//                                 },
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     AnimatedBuilder(
//                       animation: _sendButtonAnimation,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: 0.8 + (_sendButtonAnimation.value * 0.2),
//                           child: Container(
//                             width: 48,
//                             height: 48,
//                             decoration: BoxDecoration(
//                               color: kPrimaryColor,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: kPrimaryColor.withOpacity(0.3),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: IconButton(
//                               icon: Icon(
//                                 _controller.text.isNotEmpty ? Icons.send : Icons.mic,
//                                 color: kWhite,
//                                 size: 20,
//                               ),
//                               onPressed: _controller.text.isNotEmpty ? sendMessage : () {
//                                 // Voice message functionality
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }