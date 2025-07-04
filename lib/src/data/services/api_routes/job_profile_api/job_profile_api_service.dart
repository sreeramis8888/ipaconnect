import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/job_profile_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_profile_api_service.g.dart';

@riverpod
JobProfileApiService jobProfileApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return JobProfileApiService(apiService);
}

class JobProfileApiService {
  final ApiService _apiService;

  JobProfileApiService(this._apiService);

  Future<List<JobProfileModel>> getJobProfiles({
    int pageNo = 1,
    int limit = 10,
    String? category,
    String? experience,
    String? noticePeriod,
    String? location,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'page_no': pageNo.toString(),
      'limit': limit.toString(),
    };
    if (category != null && category.isNotEmpty)
      queryParams['category'] = category;
    if (experience != null && experience.isNotEmpty)
      queryParams['experience'] = experience;
    if (noticePeriod != null && noticePeriod.isNotEmpty)
      queryParams['notice_period'] = noticePeriod;
    if (location != null && location.isNotEmpty)
      queryParams['location'] = location;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '/job-profile?$uri';
    final response = await _apiService.get(endpoint);

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => JobProfileModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

@riverpod
Future<List<JobProfileModel>> getJobProfiles(
  Ref ref, {
  int pageNo = 1,
  int limit = 10,
  String? category,
  String? experience,
  String? noticePeriod,
  String? location,
  String? search,
}) async {
  final jobProfileApiService = ref.watch(jobProfileApiServiceProvider);
  return jobProfileApiService.getJobProfiles(
    pageNo: pageNo,
    limit: limit,
    category: category,
    experience: experience,
    noticePeriod: noticePeriod,
    location: location,
    search: search,
  );
}
