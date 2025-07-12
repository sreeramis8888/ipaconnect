import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_api_service.g.dart';

@riverpod
ChatApiService chatApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ChatApiService(apiService);
}

class ChatApiService {
  final ApiService _apiService;

  ChatApiService(this._apiService);

  Future<List<ConversationModel>> getConversations(
      {int pageNo = 1, int limit = 10}) async {
    final response = await _apiService
        .get('/chat/conversation?page_no=$pageNo&limit=$limit');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<ConversationModel?> create1to1Conversation(String recipientId) async {
    final response = await _apiService.post('/chat/conversations', {
      'recipient_id': recipientId,
    });
    log(name: 'Recipient_id', recipientId);
    log(response.data.toString());
    log(response.message.toString());
    if (response.success && response.data != null) {
      return ConversationModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }

  Future<bool> markDelivered(String messageId) async {
    final response = await _apiService.patch('/chat/messages/delivered', {
      'message_id': messageId,
    });
    return response.success;
  }

  Future<bool> markSeen(String messageId) async {
    final response = await _apiService.patch('/chat/messages/seen', {
      'message_id': messageId,
    });
    return response.success;
  }
}

@riverpod
Future<List<ConversationModel>> getConversations(Ref ref,
    {int pageNo = 1, int limit = 10}) async {
  final chatApiService = ref.watch(chatApiServiceProvider);
  return chatApiService.getConversations(pageNo: pageNo, limit: limit);
}
