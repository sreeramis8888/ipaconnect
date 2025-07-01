// import 'dart:developer';

// import 'package:familytree/src/data/globals.dart';
// import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
// import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';
// import 'package:familytree/src/data/models/chat_conversation_model.dart';
// import 'package:familytree/src/data/models/chat_model.dart';
// import 'package:familytree/src/data/services/socket_service.dart';

// extension ChatConversationUnread on ChatConversation {
//   int get unreadCount => (this as dynamic).unreadCount ?? 0;
// }

// bool isOtherParticipant(dynamic userId, String currentUserId) {
//   if (userId is String) return userId != currentUserId;
//   if (userId is ChatUser) return userId.id != currentUserId;
//   return false;
// }

// class ChatDash extends ConsumerStatefulWidget {
//   ChatDash({super.key});

//   @override
//   ConsumerState<ChatDash> createState() => _ChatDashState();
// }

// class _ChatDashState extends ConsumerState<ChatDash> {
//   final Map<String, Map<String, String?>> _userPresence = {};
//   late SocketService _socketService;

//   @override
//   void initState() {
//     super.initState();
//     _socketService = SocketService();
//     _socketService.onUserStatusUpdate((userId, status, lastSeen) {
//       setState(() {
//         _userPresence[userId] = {'status': status, 'lastSeen': lastSeen};
//       });
//     });
//   }

//   String timeAgo(DateTime dateTime) {
//     final now = DateTime.now();
//     final diff = now.difference(dateTime);
//     if (diff.inSeconds < 60) return 'just now';
//     if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
//     if (diff.inHours < 24) return '${diff.inHours} hr ago';
//     return '${diff.inDays} days ago';
//   }

//   String getPresenceText(String userId) {
//     final presence = _userPresence[userId];
//     if (presence == null) return '';
//     if (presence['status'] == 'online') return 'Online';
//     if (presence['lastSeen'] != null && presence['lastSeen']!.isNotEmpty) {
//       final dt = DateTime.tryParse(presence['lastSeen']!);
//       if (dt != null) return 'Last seen ' + timeAgo(dt);
//     }
//     return 'Offline';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final conversationsAsync = ref.watch(fetchChatConversationsProvider);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: conversationsAsync.when(
//         loading: () => const Center(child: LoadingAnimation()),
//         error: (error, stack) {
//           log(error.toString());
//           return SizedBox.shrink();
//         },
//         data: (chats) {
//           if (chats.isEmpty) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(child: Image.asset('assets/pngs/nochat.png')),
//                 ),
//                 const Text('No chat yet!'),
//               ],
//             );
//           }
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final conversation = chats[index];
//               String lastMessageText = '';
//               if (conversation.lastMessage != null) {
//                 lastMessageText = conversation.lastMessage ?? '';
//                 if (lastMessageText.length > 30) {
//                   lastMessageText = '${lastMessageText.substring(0, 30)}...';
//                 }
//               }
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.white,
//                   backgroundImage: conversation.participantDetails.length > 1 &&
//                  conversation.participantDetails[1].image != null &&
//                  conversation.participantDetails[1].image!.isNotEmpty
//     ? NetworkImage(conversation.participantDetails[1].image!)
//     : null,

//                     ),
//                     title: Text(conversation.name ?? 'Chat'),
//                     subtitle: Text(lastMessageText),
//                     trailing: const SizedBox.shrink(),
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => IndividualPage(
//                           conversation: conversation,
//                           currentUserId: id,
//                         ),
//                       ));
//                     },
//                   ),
//                   Divider(
//                     thickness: 1,
//                     height: 1,
//                     color: Colors.grey[350],
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
