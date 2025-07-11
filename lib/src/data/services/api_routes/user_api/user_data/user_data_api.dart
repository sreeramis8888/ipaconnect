import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import '../../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_api.g.dart';

class UserDataApiService {
  final ApiService _apiService;

  UserDataApiService(this._apiService);

  Future<ApiResponse<Map<String, dynamic>>> updateUser(
      String userId, UserModel user) async {
    final response = await _apiService.patch(
      '/users/update',
      user.toJson(),
    );
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
  Future<List<UserModel>> fetchAllUsers({int pageNo = 1, int limit = 10}) async {
    final response = await _apiService.get('/users');

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
Future<List<UserModel>> fetchAllUsers(Ref ref,{int pageNo = 1, int limit = 10}) async {
  final userApiService = ref.watch(userDataApiServiceProvider);
  return userApiService.fetchAllUsers(limit: limit,pageNo: pageNo);
}