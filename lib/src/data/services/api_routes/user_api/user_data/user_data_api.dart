import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import '../../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_api.g.dart';

class UserDataApiService {
  final ApiService _apiService;

  UserDataApiService(this._apiService);

  Future<ApiResponse<Map<String, dynamic>>> updateUser(String userId, UserModel user) async {
    final response = await _apiService.patch(
      '/users/$userId',
      user.toJson(),
    );
    return response;
  }

  Future<UserModel?> fetchUserDetails() async {
    final response = await _apiService.get('/users/profile');
    if (response.success && response.data != null) {
      return UserModel.fromJson(response.data!);
    }
    return null;
  }
  Future<UserModel?> fetchUserDetailsById(String userId) async {
    final response = await _apiService.get('/users/$userId');
    if (response.success && response.data != null) {
      return UserModel.fromJson(response.data!);
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
Future<UserModel?> getUserDetailsById(Ref ref,{required String userId}) async {
  final userDataApi = ref.watch(userDataApiServiceProvider);
  return userDataApi.fetchUserDetailsById(userId);
}
