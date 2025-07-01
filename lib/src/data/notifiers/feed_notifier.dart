import 'dart:developer';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_notifier.g.dart';

@riverpod
class FeedNotifier extends _$FeedNotifier {
  List<FeedModel> businesses = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 5;
  bool hasMore = true;

  @override
  List<FeedModel> build() {
    return [];
  }

  Future<void> fetchMoreFeed() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newBusinesses = await ref
          .read(getFeedsProvider(pageNo: pageNo, limit: limit).future);

      if (newBusinesses.isEmpty) {
        hasMore = false;
      } else {
        businesses = [...businesses, ...newBusinesses];
        pageNo++;
        // Only set hasMore to false if we get fewer items than the limit
        hasMore = newBusinesses.length >= limit;
      }

      isFirstLoad = false;
      state = businesses;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshFeed() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedBusinesses = await ref
          .read(getFeedsProvider(pageNo: pageNo, limit: limit).future);

      businesses = refreshedBusinesses;
      hasMore = refreshedBusinesses.length >= limit;
      isFirstLoad = false;
      state = businesses;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
