import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
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
    _socketService.subscribeConversations(onAck: (err) {
      if (err != null) {
        setState(() {
          _socketError = err;
          _socketLoading = false;
        });
      }
    });
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
              child: Center(child: Image.asset('assets/pngs/nochat.png')),
            ),
            const Text('No chat yet!'),
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
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: (user != null &&
                                user.image != null &&
                                user.image!.isNotEmpty)
                            ? NetworkImage(user.image!)
                            : null,
                        child: (user == null ||
                                user.image == null ||
                                user.image!.isEmpty)
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        user?.name ?? conversation.name ?? 'Chat',
                        style: kBodyTitleR,
                      ),
                      subtitle: Text(
                        lastMessageText,
                        style: TextStyle(color: kSecondaryTextColor),
                      ),
                      trailing: const SizedBox.shrink(),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            conversationId: conversation.id ?? '',
                            chatTitle: conversation.name ?? '',
                            userId: user?.id ?? '',
                          ),
                        ));
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
