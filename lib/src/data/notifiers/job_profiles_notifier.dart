import 'dart:developer';
import 'package:ipaconnect/src/data/models/job_profile_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/job_profile_api/job_profile_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_profiles_notifier.g.dart';

@riverpod
class JobProfilesNotifier extends _$JobProfilesNotifier {
  List<JobProfileModel> jobProfiles = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;
  String? searchQuery;
  String? category;
  String? experience;
  String? noticePeriod;
  String? location;
  String? search;

  @override
  List<JobProfileModel> build() {
    return [];
  }

  Future<void> fetchMoreJobProfiles({
    String? category,
    String? experience,
    String? noticePeriod,
    String? location,
    String? search,
  }) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final result = await ref.read(getJobProfilesProvider(
        pageNo: pageNo,
        limit: limit,
        category: category ?? this.category,
        experience: experience ?? this.experience,
        noticePeriod: noticePeriod ?? this.noticePeriod,
        location: location ?? this.location,
        search: search ?? this.search,
      ).future);
      final newProfiles = result as List<JobProfileModel>?;
      if (newProfiles == null || newProfiles.isEmpty) {
        hasMore = false;
      } else {
        jobProfiles = [...jobProfiles, ...newProfiles];
        pageNo++;
        hasMore = newProfiles.length >= limit;
      }
      isFirstLoad = false;
      state = jobProfiles;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }


  Future<void> searchJobProfiles(String query,
     ) async {
    isLoading = true;
    pageNo = 1;
    jobProfiles = [];
    searchQuery = query;

    try {
      final newJobProfiles = await ref.read(
        getJobProfilesProvider(
          pageNo: pageNo,
          limit: limit,
          search: query,
        ).future,
      );

      jobProfiles = [...newJobProfiles];
      hasMore = newJobProfiles.length == limit;

      state = [...newJobProfiles];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
  Future<void> refreshJobProfiles({
    String? category,
    String? experience,
    String? noticePeriod,
    String? location,
    String? search,
  }) async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final result = await ref.read(getJobProfilesProvider(
        pageNo: pageNo,
        limit: limit,
        category: category ?? this.category,
        experience: experience ?? this.experience,
        noticePeriod: noticePeriod ?? this.noticePeriod,
        location: location ?? this.location,
        search: search ?? this.search,
      ).future);
      final refreshedProfiles = result as List<JobProfileModel>?;
      jobProfiles = refreshedProfiles ?? [];
      hasMore = (refreshedProfiles?.length ?? 0) >= limit;
      isFirstLoad = false;
      state = jobProfiles;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  void setFilters(
      {String? category,
      String? experience,
      String? noticePeriod,
      String? location,
      String? search}) {
    this.category = category;
    this.experience = experience;
    this.noticePeriod = noticePeriod;
    this.location = location;
    this.search = search;
    pageNo = 1;
    jobProfiles = [];
    hasMore = true;
    isFirstLoad = true;
    // fetchMoreJobProfiles(); // Remove auto-fetch, let UI call fetch explicitly
  }
}
