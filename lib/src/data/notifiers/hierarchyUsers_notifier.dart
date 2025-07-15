import 'dart:developer';
import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/campain_api/campaign_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/hierarchy/hierarchy_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hierarchyUsers_notifier.g.dart';

@riverpod
class HierarchyusersNotifier extends _$HierarchyusersNotifier {
  List<UserModel> hierarchyUsers = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 15;
  bool hasMore = true;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreHierarchyUsers({required String hierarchyId}) async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newHierarchyUsers = await ref.read(getHierarchyUsersProvider(
              hierarchyId: hierarchyId, page: pageNo, limit: limit)
          .future);

      if (newHierarchyUsers.isEmpty) {
        hasMore = false;
      } else {
        hierarchyUsers = [...hierarchyUsers, ...newHierarchyUsers];
        pageNo++;
        hasMore = newHierarchyUsers.length >= limit;
      }

      isFirstLoad = false;
      state = hierarchyUsers;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshHierarchyUsers({required String hierarchyId}) async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedHierarchies = await ref.read(getHierarchyUsersProvider(
              hierarchyId: hierarchyId, page: pageNo, limit: limit)
          .future);

      hierarchyUsers = refreshedHierarchies;
      hasMore = refreshedHierarchies.length >= limit;
      isFirstLoad = false;
      state = hierarchyUsers;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
