import 'dart:developer';
import 'package:ipaconnect/src/data/models/analytics_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'analytics_api.g.dart';

class AnalyticsApiService {
  final ApiService apiService;
  final SnackbarService snackbarService;

  AnalyticsApiService({required this.apiService, SnackbarService? snackbarService})
      : snackbarService = snackbarService ?? SnackbarService();

Future<List<AnalyticsModel>> fetchAnalytics({
  int? page,
  int? limit,
}) async {
  final queryParams = <String, String>{};
  if (page != null) queryParams['page'] = page.toString();
  if (limit != null) queryParams['limit'] = limit.toString();

  final queryString = queryParams.entries.isNotEmpty
      ? '?' + queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')
      : '';

  final endpoint = '/activity/user/$id$queryString';

  try {
    final response = await apiService.get(endpoint);
    final decoded = response.data;
    if (response.success && response.statusCode == 200) {
      final List data = decoded?['data'] ?? [];
      return data.map((item) => AnalyticsModel.fromJson(item)).toList();
    } else {
      throw Exception(decoded?['message'] ?? response.message ?? 'Failed to fetch analytics');
    }
  } catch (e) {
    log('Exception in fetchAnalytics: $e');
    return [];
  }
}

  /// Post Analytics
  Future<String?> postAnalytic({required Map<String, dynamic> data}) async {
    try {
      final response = await apiService.post('/analytic', data);
      final decoded = response.data;
      if (response.success && (response.statusCode == 200 || response.statusCode == 201)) {
        log('Analytics posted successfully: ${response.data}');
        return 'success';
      } else {
        return decoded?['message'] ?? response.message;
      }
    } catch (e) {
      log('Exception in posting analytics: $e');
      return e.toString();
    }
  }

  /// Update Analytics Status
  Future<void> updateAnalyticStatus({
    required String analyticId,
    required String? action,
  }) async {
    final endpoint = '/analytic/status';
    final body = {
      'requestId': analyticId,
      'action': action,
    };
    try {
      final response = await apiService.post(endpoint, body);
      if (response.success && (response.statusCode == 200 || response.statusCode == 201)) {
        log('$action successfully applied');
      } else {
        log('Failed to update analytic status: ${response.statusCode}');
        log('Response: ${response.data}');
      }
    } catch (e) {
      log('Error updating analytic status: $e');
    }
  }

  /// Delete Analytic
  Future<void> deleteAnalytic({required String analyticId}) async {
    final endpoint = '/analytic/$analyticId';
    try {
      final response = await apiService.delete(endpoint);
      if (response.success && (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204)) {
        log('Analytic deleted successfully');
      } else {
        log('Failed to delete analytic: ${response.statusCode}');
        log('Response: ${response.data}');
      }
    } catch (e) {
      log('Error deleting analytic: $e');
    }
  }
}

@riverpod
AnalyticsApiService analyticsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AnalyticsApiService(apiService: apiService);
}

@riverpod
Future<List<AnalyticsModel>> fetchAnalytics(
  Ref ref, {
  required String? type,
  String? startDate,
  String? endDate,
  String? requestType,
  int? pageNo,
  int? limit,
}) {
  final analyticsApi = ref.watch(analyticsApiServiceProvider);
  return analyticsApi.fetchAnalytics(
    limit: limit,
  );
}
