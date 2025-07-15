import 'dart:developer';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/rating_api/rating_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rating_notifier.g.dart';

@riverpod
class RatingNotifier extends _$RatingNotifier {
  List<RatingModel> ratings = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;
  String? entityId;
  String? entityType;

  @override
  List<RatingModel> build() {
    return [];
  }

  Future<void> fetchMoreRatings(
      {required String entityId, required String entityType}) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final newRatings = await ref.read(getRatingsByEntityProvider(
        entityId: entityId,
        entityType: entityType,
        pageNo: pageNo,
        limit: limit,
      ).future);
      if (newRatings.isEmpty) {
        hasMore = false;
      } else {
        ratings = [...ratings, ...newRatings];
        pageNo++;
        hasMore = newRatings.length >= limit;
      }
      isFirstLoad = false;
      state = ratings;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchMoreMyRatings({required String entityType}) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final newRatings = await ref.read(getMyRatingsProvider(
        entityType: entityType,
        pageNo: pageNo,
        limit: limit,
      ).future);
      if (newRatings.isEmpty) {
        hasMore = false;
      } else {
        ratings = [...ratings, ...newRatings];
        pageNo++;
        hasMore = newRatings.length >= limit;
      }
      isFirstLoad = false;
      state = ratings;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshRatings(
      {required String entityId, required String entityType}) async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final refreshedRatings = await ref.read(getRatingsByEntityProvider(
        entityId: entityId,
        entityType: entityType,
        pageNo: pageNo,
        limit: limit,
      ).future);
      ratings = refreshedRatings;
      hasMore = refreshedRatings.length >= limit;
      isFirstLoad = false;
      state = ratings;
      log('Ratings refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<RatingModel?> addRating({
    required String userId,
    required String userName,
    required String targetId,
    required String targetType,
    required int rating,
    required String review,
  }) async {
    final service = ref.read(ratingApiServiceProvider);
    final newRating = await service.postRating(
      userId: userId,
      userName: userName,
      targetId: targetId,
      targetType: targetType,
      rating: rating,
      review: review,
    );
    if (newRating != null) {
      ratings = [newRating, ...ratings];
      state = ratings;
    }
    return newRating;
  }

  Future<RatingModel?> updateRating({
    required String id,
    required int rating,
    required String review,
  }) async {
    final service = ref.read(ratingApiServiceProvider);
    final updated =
        await service.updateRating(id: id, rating: rating, review: review);
    if (updated != null) {
      ratings = ratings.map((r) => r.id == id ? updated : r).toList();
      state = ratings;
    }
    return updated;
  }

  Future<bool> deleteRating(String id) async {
    final service = ref.read(ratingApiServiceProvider);
    final success = await service.deleteRating(id);
    if (success) {
      ratings = ratings.where((r) => r.id != id).toList();
      state = ratings;
    }
    return success;
  }
}
