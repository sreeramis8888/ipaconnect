import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rating_api_service.g.dart';

@riverpod
RatingApiService ratingApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RatingApiService(apiService);
}

class RatingApiService {
  final ApiService _apiService;

  RatingApiService(this._apiService);

  Future<RatingModel?> postRating({
    required String userId,
    required String userName,
    required String targetId,
    required String targetType,
    required int rating,
    required String review,
  }) async {
    final body = {
      'to': targetId,
      'to_model': targetType,
      'rating': rating,
      'comment': review,
    };
    log(body.toString(), name: 'Posting Rating');
    final response = await _apiService.post('/rating', body);
    log(response.message.toString(), name: 'Rating posted response');
    if (response.success && response.data != null) {
      return RatingModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }

  Future<List<RatingModel>> getRatingsByEntity({
    required String entityId,
    required String entityType,
    int pageNo = 1,
    int limit = 10,
  }) async {
    final response = await _apiService.get(
        '/rating/by-entity/$entityId?page=$pageNo&limit=$limit&entity=$entityType');
    log(name: 'RATING GET RESPONSE', '${response.data}');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => RatingModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<RatingModel?> getRatingById(String id) async {
    final response = await _apiService.get('/rating/$id');
    if (response.success && response.data != null) {
      return RatingModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }

  Future<RatingModel?> updateRating({
    required String id,
    required int rating,
    required String review,
  }) async {
    final body = {
      'rating': rating,
      'review': review,
    };
    final response = await _apiService.put('/rating/$id', body);
    if (response.success && response.data != null) {
      return RatingModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }

  Future<bool> deleteRating(String id) async {
    final response = await _apiService.delete('/rating/$id');
    return response.success;
  }
}

@riverpod
Future<List<RatingModel>> getRatingsByEntity(
  Ref ref, {
  required String entityId,
  required String entityType,
  int pageNo = 1,
  int limit = 10,
}) {
  final service = ref.watch(ratingApiServiceProvider);
  return service.getRatingsByEntity(
    entityId: entityId,
    entityType: entityType,
    pageNo: pageNo,
    limit: limit,
  );
}
