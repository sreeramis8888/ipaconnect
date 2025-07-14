import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import '../../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_api.g.dart';

class UserDataApiService {
  final ApiService _apiService;

  UserDataApiService(this._apiService);
  Future<ApiResponse<Map<String, dynamic>>> updateUser(
      String userId, UserModel user) async {
    final filteredJson = user.toJson()
      ..removeWhere((key, value) => value == null);

    final response = await _apiService.patch(
      '/users/update',
      filteredJson,
    );

    log('Requesting body: $filteredJson');
    log(response.message.toString());

    return response;
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteUser(String userId) async {
    final response = await _apiService.delete(
      '/users/$userId',
    );

    log(response.message.toString());

    return response;
  }

  Future<UserModel?> fetchUserDetails() async {
    final response = await _apiService.get('/users/profile');
    log(response.data.toString());
    if (response.success && response.data != null) {
      log(response.data.toString());
      return UserModel.fromJson(response.data!['data']);
    }
    return null;
  }

  Future<List<UserModel>> fetchAllUsers({
    int pageNo = 1,
    int limit = 10,
    String? query,
  }) async {
    Map<String, String> queryParams = {};
    if (query != null && query.isNotEmpty) {
      queryParams['search'] = query;
    }

    final response = await _apiService.get(
        '/users?page_no=$pageNo&limit=$limit&${Uri(queryParameters: queryParams).query}');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<UserModel?> fetchUserDetailsById(String userId) async {
    final response = await _apiService.get('/users/$userId');
    if (response.success && response.data != null) {
      return UserModel.fromJson(response.data!['data']);
    }
    return null;
  }

  Future<void> createReport({
    required String reportedItemId,
    required String reportType,
    required String reason,
  }) async {
    final body = {
      'report_id': reportedItemId.isNotEmpty ? reportedItemId : ' ',
      'report_type': reportType,
      'reason': reason,
    };

    try {
      final response = await _apiService.post('/report', body);
      log(response.data.toString(), name: 'report respose data');
      log(response.message.toString(), name: 'report respose message');
      if (response.success &&
          (response.statusCode == 201 || response.statusCode == 200)) {
        SnackbarService().showSnackBar('Reported to admin');
      } else {
        SnackbarService().showSnackBar('Failed to Report');
      }
    } catch (e) {
      log('Error occurred: $e');
    }
  }

  Future<void> blockUser(String userId, String? reason, WidgetRef ref) async {
    final response = await _apiService.put(
      '/users/block-user/$userId',
      {},
    );
    log(response.data.toString(), name: 'block User respose data');
    log(response.message.toString(), name: 'block User respose message');
    if (response.success && response.statusCode == 200) {
      ref.read(userProvider.notifier).refreshUser();
      SnackbarService().showSnackBar('Blocked');
    } else {
      SnackbarService().showSnackBar('Failed to Block');
    }
  }

  Future<void> unBlockUser(String userId) async {
    final response = await _apiService.put(
      '/users/block-user/$userId',
      {},
    );
    if (response.success && response.statusCode == 200) {
      SnackbarService().showSnackBar('User unblocked successfully');
    } else {
      SnackbarService().showSnackBar('Failed to UnBlock');
    }
  }
}

@riverpod
UserDataApiService userDataApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserDataApiService(apiService);
}

@riverpod
Future<UserModel?> getUserDetails(Ref ref) async {
  final userDataApi = ref.watch(userDataApiServiceProvider);
  return userDataApi.fetchUserDetails();
}

@riverpod
Future<UserModel?> getUserDetailsById(Ref ref, {required String userId}) async {
  final userDataApi = ref.watch(userDataApiServiceProvider);
  return userDataApi.fetchUserDetailsById(userId);
}

@riverpod
Future<List<UserModel>> fetchAllUsers(
  Ref ref, {
  int pageNo = 1,
  int limit = 10,
  String? query,
}) async {
  final userApiService = ref.watch(userDataApiServiceProvider);
  return userApiService.fetchAllUsers(
      limit: limit, pageNo: pageNo, query: query);
}
