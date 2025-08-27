import 'dart:developer';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'members_notifier.g.dart';

@riverpod
class MembersNotifier extends _$MembersNotifier {
  List<UserModel> users = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;
  String? searchQuery;
  String? district;
  String? clusterId;
  bool isFirstLoad = true;
  List<String>? tags;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreUsers() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    Future(() {
      state = [...users];
    });

    try {
      final newUsers = await ref.read(
        fetchAllUsersProvider(
          pageNo: pageNo,
          limit: limit,
          hierarchyId: clusterId,
          query: searchQuery,
        ).future,
      );

      users = [...users, ...newUsers];
      pageNo++;
      isFirstLoad = false;
      hasMore = newUsers.length == limit;

      Future(() {
        state = [...users];
      });
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;

      Future(() {
        state = [...users];
      });

      log('Fetched users: $users');
    }
  }

  Future<void> searchUsers(String query,
      {String? districtFilter, List<String>? tagsFilter}) async {
    isLoading = true;
    pageNo = 1;
    users = [];
    searchQuery = query;

    try {
      final newUsers = await ref.read(
        fetchAllUsersProvider(
          pageNo: pageNo,
          limit: limit,
          query: query,
          hierarchyId: clusterId,
        ).future,
      );

      users = [...newUsers];
      hasMore = newUsers.length == limit;

      state = [...users];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    pageNo = 1;
    hasMore = true;
    users = [];
    state = [...users];

    try {
      final newUsers = await ref.read(
        fetchAllUsersProvider(
          pageNo: pageNo,
          limit: limit,
          query: searchQuery,
          hierarchyId: clusterId,
        ).future,
      );

      users = [...newUsers];
      hasMore = newUsers.length == limit;

      state = [...users];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  void setDistrict(String? newDistrict) {
    district = newDistrict;
    refresh(); // Auto-refresh when district is updated
  }

  void setCluster(String? newClusterId) {
    if (clusterId == newClusterId) return;
    clusterId = newClusterId;
    // Reset pagination and refresh with new filter
    pageNo = 1;
    hasMore = true;
    users = [];
    refresh();
  }

  void setTags(List<String>? newTags) {
    tags = newTags;
    refresh(); // Auto-refresh when tags are updated
  }
}
