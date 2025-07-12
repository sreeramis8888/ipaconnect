import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_api_service.g.dart';

@riverpod
FeedApiService feedApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FeedApiService(apiService);
}

class FeedApiService {
  final ApiService _apiService;

  FeedApiService(this._apiService);

  Future<List<FeedModel>> getFeeds({int pageNo = 1, int limit = 10}) async {
    final response = await _apiService
        .get('/requirements?page_no=$pageNo&limit=$limit&status=published');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => FeedModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<FeedModel>> getMyFeeds({int pageNo = 1, int limit = 10}) async {
    final response = await _apiService
        .get('/requirements/self?page_no=$pageNo&limit=$limit&status=published');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => FeedModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> uploadFeed(
      {required String? media, required String content}) async {
    final response = await _apiService.post('/requirements', {
      if (media != null && media != '') 'media': media,
      'content': content,
    });

    if (response.success && response.data != null) {
      print('Feed created successfully');
    } else {
      print('Failed to create business: ${response.statusCode}');
      print('Response message: ${response.message}');
    }
  }

  Future<void> likeFeed({required String feedId}) async {
    final response = await _apiService.post('/requirements/like/$feedId', {});
    if (response.success && response.data != null) {
      print('Feed liked successfully');
    } else {
      print('Failed to like feed: ${response.statusCode}');
      print('Response message: ${response.message}');
    }
  }

  Future<void> commentFeed(
      {required String feedId, required String comment}) async {
    final response = await _apiService.post('/requirements/comment/$feedId', {
      'comment': comment,
    });
    if (response.success && response.data != null) {
      print('Comment added successfully');
    } else {
      print('Failed to add comment: ${response.statusCode}');
      print('Response message: ${response.message}');
    }
  }
}

@riverpod
Future<List<FeedModel>> getFeeds(Ref ref,
    {int pageNo = 1, int limit = 10}) async {
  final feedApiService = ref.watch(feedApiServiceProvider);
  return feedApiService.getFeeds(pageNo: pageNo, limit: limit);
}
@riverpod
Future<List<FeedModel>> getMyFeeds(Ref ref,
    {int pageNo = 1, int limit = 10}) async {
  final feedApiService = ref.watch(feedApiServiceProvider);
  return feedApiService.getMyFeeds(pageNo: pageNo, limit: limit);
}
