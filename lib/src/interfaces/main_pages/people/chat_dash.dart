import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/socket_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_screen.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';

class ChatDash extends ConsumerStatefulWidget {
  ChatDash({super.key});

  @override
  ConsumerState<ChatDash> createState() => _ChatDashState();
}

class _ChatDashState extends ConsumerState<ChatDash> {
  final Map<String, Map<String, String?>> _userPresence = {};
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
  }

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = ref.watch(getConversationsProvider());

    return Scaffold(
      backgroundColor: Colors.white,
      body: conversationsAsync.when(
        loading: () => const Center(child: LoadingAnimation()),
        error: (error, stack) {
          log(error.toString());
          return SizedBox.shrink();
        },
        data: (chats) {
          if (chats.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Image.asset('assets/pngs/nochat.png')),
                ),
                const Text('No chat yet!'),
              ],
            );
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final conversation = chats[index];
              String lastMessageText = '';
              if (conversation.lastMessage != null) {
                lastMessageText = conversation.lastMessage ?? '';
                if (lastMessageText.length > 30) {
                  lastMessageText = '${lastMessageText.substring(0, 30)}...';
                }
              }
              // Find the other participant (for 1-to-1 chat)
              final otherMemberId = (conversation.members ?? [])
                  .firstWhere((memberId) => memberId != id, orElse: () => '');
              return Column(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      if (otherMemberId == null || otherMemberId.isEmpty) {
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(conversation.name ?? 'Chat'),
                          subtitle: Text(lastMessageText),
                          trailing: const SizedBox.shrink(),
                        );
                      }
                      final userAsync = ref.watch(getUserDetailsByIdProvider(userId: otherMemberId));
                      return userAsync.when(
                        loading: () => ListTile(
                          leading: const CircleAvatar(child: CircularProgressIndicator()),
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
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: (user != null && user.image != null && user.image!.isNotEmpty)
                                ? NetworkImage(user.image!)
                                : null,
                            child: (user == null || user.image == null || user.image!.isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(user?.name ?? conversation.name ?? 'Chat'),
                          subtitle: Text(lastMessageText),
                          trailing: const SizedBox.shrink(),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                conversationId: conversation.id??'',chatTitle: conversation.name??'',
                                userId: user?.id??'',
                              ),
                            ));
                          },
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey[350],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}