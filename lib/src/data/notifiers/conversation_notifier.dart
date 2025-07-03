import 'dart:developer';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_notifier.g.dart';

@riverpod
class ConversationNotifier extends _$ConversationNotifier {
  List<ConversationModel> conversations = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 5;
  bool hasMore = true;

  @override
  List<ConversationModel> build() {
    return [];
  }

  Future<void> fetchMoreConversation() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newConversations = await ref
          .read(getConversationsProvider(pageNo: pageNo, limit: limit).future);

      if (newConversations.isEmpty) {
        hasMore = false;
      } else {
        conversations = [...conversations, ...newConversations];
        pageNo++;
        // Only set hasMore to false if we get fewer items than the limit
        hasMore = newConversations.length >= limit;
      }

      isFirstLoad = false;
      state = conversations;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshConversation() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedConversations = await ref
          .read(getConversationsProvider(pageNo: pageNo, limit: limit).future);

      conversations = refreshedConversations;
      hasMore = refreshedConversations.length >= limit;
      isFirstLoad = false;
      state = conversations;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
